from __future__ import annotations

"""Reference preprocessing helpers for rsaToolbox v2.0.2.

This module implements a transparent reference pipeline for generating
rsaToolbox-compatible input files from VivoLogic-style exports and from
manually prepared generic inputs.

Important scope note
--------------------
The code below reproduces the behavior visible in the provided example data for
VivoLogic exports:
- TTOT is taken from respiratory cycle durations, starting with the *second*
  respiratory row (the first full usable cycle in the example data)
- VT is computed as (ViVol + VeVol) / 2000 in liters
- IBI is generated on the breath-aligned time base: the first IBI is the
  interval from the first usable breath start to the first following R-peak;
  all later IBI values are taken from the RR column in milliseconds

For truly generic non-Vivo data, users still need to define how respiratory
cycles are detected and how beat artifacts are flagged. This file provides a
clean specification and helpers, but it cannot infer missing physiology-specific
choices from arbitrary raw signals.
"""

from dataclasses import dataclass
from pathlib import Path
from typing import Iterable, Optional
import argparse
import csv
import math

import pandas as pd


TIMESTAMP_COLUMNS = ("YYYY/MM/DD", "H: M: S: MS")
RESP_COLUMNS = ("ViVol", "VeVol", "Tt")
RR_COLUMN = "RR"


@dataclass
class BreathSeries:
    start_times: pd.Series
    ttot_s: pd.Series
    vt_l: pd.Series
    ttot_flag: pd.Series


@dataclass
class IbiSeries:
    ibi_ms: pd.Series
    ibi_flag: pd.Series


@dataclass
class RsaToolboxInput:
    ibi: pd.Series
    ibi_flag: pd.Series
    ttot: pd.Series
    ttot_flag: pd.Series
    vt: pd.Series


# ---------------------------------------------------------------------------
# Parsing helpers
# ---------------------------------------------------------------------------


def _read_csv_trimmed(path: Path) -> pd.DataFrame:
    df = pd.read_csv(path, skipinitialspace=True)
    df.columns = [str(c).strip() for c in df.columns]
    return df


def _parse_timestamp(df: pd.DataFrame) -> pd.Series:
    missing = [c for c in TIMESTAMP_COLUMNS if c not in df.columns]
    if missing:
        raise ValueError(f"Missing timestamp columns: {missing}")
    date_part = df[TIMESTAMP_COLUMNS[0]].astype(str).str.strip()
    time_part = df[TIMESTAMP_COLUMNS[1]].astype(str).str.strip()
    return pd.to_datetime(
        date_part + " " + time_part,
        format="%Y/%m/%d %H:%M:%S:%f",
        errors="raise",
    )


def read_vivologic_resp(resp_csv: Path) -> pd.DataFrame:
    df = _read_csv_trimmed(resp_csv)
    for col in RESP_COLUMNS:
        if col not in df.columns:
            raise ValueError(f"Missing respiration column '{col}' in {resp_csv}")
    df = df.copy()
    df["timestamp"] = _parse_timestamp(df)
    for col in RESP_COLUMNS:
        df[col] = pd.to_numeric(df[col], errors="raise")
    return df


def read_vivologic_rr(rr_csv: Path) -> pd.DataFrame:
    df = _read_csv_trimmed(rr_csv)
    if RR_COLUMN not in df.columns:
        raise ValueError(f"Missing RR column '{RR_COLUMN}' in {rr_csv}")
    df = df.copy()
    df["timestamp"] = _parse_timestamp(df)
    df[RR_COLUMN] = pd.to_numeric(df[RR_COLUMN], errors="raise")
    return df


# ---------------------------------------------------------------------------
# Example-aligned VivoLogic pipeline
# ---------------------------------------------------------------------------


def derive_breath_series_from_vivologic(resp_df: pd.DataFrame) -> BreathSeries:
    """Generate TTOT/VT series matching the provided example dataset.

    Behavior aligned to the uploaded example:
    - The first respiratory row is not emitted into TTOT/VT output.
    - Usable breaths therefore start at row index 1 of the raw export.
    - TTOT is copied from column Tt in seconds.
    - VT is computed as (ViVol + VeVol) / 2000 in liters.
    - TTOTflag defaults to 0 for all emitted breaths.
    """

    if len(resp_df) < 2:
        raise ValueError("Respiration export must contain at least 2 rows")

    usable = resp_df.iloc[1:].copy().reset_index(drop=True)
    ttot = usable["Tt"].astype(float)
    vt = (usable["ViVol"].astype(float) + usable["VeVol"].astype(float)) / 2000.0
    ttot_flag = pd.Series([0] * len(usable), dtype=int)
    return BreathSeries(
        start_times=usable["timestamp"],
        ttot_s=ttot,
        vt_l=vt,
        ttot_flag=ttot_flag,
    )


def derive_ibi_series_from_vivologic(rr_df: pd.DataFrame, first_breath_start: pd.Timestamp) -> IbiSeries:
    """Generate breath-aligned IBI values matching the example behavior.

    Observed rule in the provided example data:
    - locate the first RR timestamp >= first usable breath start
    - first emitted IBI = first_R_timestamp - first_breath_start (ms), flag=1
    - all subsequent emitted IBI values = RR column values from that first usable RR row onward, converted to ms
    - all subsequent flags default to 0
    """

    rr_after = rr_df.loc[rr_df["timestamp"] >= first_breath_start].copy().reset_index(drop=True)
    if rr_after.empty:
        raise ValueError("No RR timestamps occur at or after the first usable breath start")

    first_partial_ms = int(round((rr_after.loc[0, "timestamp"] - first_breath_start).total_seconds() * 1000.0))
    rr_ms = [int(round(v * 1000.0)) for v in rr_after[RR_COLUMN].astype(float).tolist()]

    ibi = pd.Series([first_partial_ms] + rr_ms, dtype=int)
    flags = pd.Series([1] + [0] * len(rr_ms), dtype=int)
    return IbiSeries(ibi_ms=ibi, ibi_flag=flags)


def preprocess_vivologic_pair(resp_csv: Path, rr_csv: Path) -> RsaToolboxInput:
    resp_df = read_vivologic_resp(resp_csv)
    rr_df = read_vivologic_rr(rr_csv)

    breath = derive_breath_series_from_vivologic(resp_df)
    ibi = derive_ibi_series_from_vivologic(rr_df, first_breath_start=breath.start_times.iloc[0])

    return RsaToolboxInput(
        ibi=ibi.ibi_ms,
        ibi_flag=ibi.ibi_flag,
        ttot=breath.ttot_s,
        ttot_flag=breath.ttot_flag,
        vt=breath.vt_l,
    )


# ---------------------------------------------------------------------------
# Generic helpers for non-Vivo data
# ---------------------------------------------------------------------------


def build_generic_breath_series(
    breath_start_times: Iterable[pd.Timestamp],
    inspiratory_volume: Iterable[float],
    expiratory_volume: Iterable[float],
    *,
    volume_unit_divisor: float = 2000.0,
    ttot_flags: Optional[Iterable[int]] = None,
) -> BreathSeries:
    """Create TTOT/VT from already detected respiratory cycles.

    This function assumes that inspiration onsets have already been identified.
    TTOT[i] is the interval between breath_start[i] and breath_start[i+1].
    Therefore, N breath starts produce N-1 usable TTOT/VT rows.
    """

    start_times = pd.Series(list(breath_start_times))
    vi = pd.Series(list(inspiratory_volume), dtype=float)
    ve = pd.Series(list(expiratory_volume), dtype=float)

    if len(start_times) < 2:
        raise ValueError("At least two breath starts are required")
    if len(start_times) != len(vi) or len(start_times) != len(ve):
        raise ValueError("breath_start_times, inspiratory_volume, and expiratory_volume must have equal length")

    ttot = (start_times.shift(-1) - start_times).dt.total_seconds().iloc[:-1].reset_index(drop=True)
    vt = ((vi.iloc[1:].reset_index(drop=True) + ve.iloc[1:].reset_index(drop=True)) / volume_unit_divisor)
    usable_starts = start_times.iloc[1:].reset_index(drop=True)

    if ttot_flags is None:
        flags = pd.Series([0] * len(ttot), dtype=int)
    else:
        flags = pd.Series(list(ttot_flags), dtype=int)
        if len(flags) != len(ttot):
            raise ValueError("ttot_flags must match the number of usable breaths")

    return BreathSeries(start_times=usable_starts, ttot_s=ttot, vt_l=vt, ttot_flag=flags)


def build_generic_ibi_series(
    rpeak_times: Iterable[pd.Timestamp],
    *,
    first_breath_start: pd.Timestamp,
    rr_flags: Optional[Iterable[int]] = None,
) -> IbiSeries:
    """Build the example-aligned IBI series from R-peak timestamps.

    This mirrors the rule visible in the example data:
    - first partial interval from breath start to the first following R-peak
    - thereafter true RR intervals between consecutive retained R-peaks
    """

    r = pd.Series(list(rpeak_times)).sort_values().reset_index(drop=True)
    r = r[r >= first_breath_start].reset_index(drop=True)
    if r.empty:
        raise ValueError("No R-peaks occur at or after first_breath_start")

    first_partial_ms = int(round((r.iloc[0] - first_breath_start).total_seconds() * 1000.0))
    rr_ms = ((r - r.shift(1)).dt.total_seconds() * 1000.0).iloc[1:].round().astype(int).tolist()
    ibi = pd.Series([first_partial_ms] + rr_ms, dtype=int)

    if rr_flags is None:
        flags = pd.Series([1] + [0] * len(rr_ms), dtype=int)
    else:
        rr_flags = list(rr_flags)
        if len(rr_flags) != len(r):
            raise ValueError("rr_flags must match the number of retained R-peaks")
        flags = pd.Series([1] + rr_flags, dtype=int)
    return IbiSeries(ibi_ms=ibi, ibi_flag=flags)


# ---------------------------------------------------------------------------
# Writing helpers
# ---------------------------------------------------------------------------


def write_series_plain(path: Path, series: pd.Series, *, float_format: str = "{:g}") -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="") as f:
        for value in series.tolist():
            if isinstance(value, float):
                if math.isnan(value):
                    f.write("NaN\n")
                else:
                    f.write(float_format.format(value) + "\n")
            else:
                f.write(f"{value}\n")


def write_rsatoolbox_input(output_prefix: Path, data: RsaToolboxInput) -> None:
    write_series_plain(output_prefix.with_name(output_prefix.name + "_IBI.csv"), data.ibi)
    write_series_plain(output_prefix.with_name(output_prefix.name + "_IBIflag.csv"), data.ibi_flag)
    write_series_plain(output_prefix.with_name(output_prefix.name + "_TTOT.csv"), data.ttot)
    write_series_plain(output_prefix.with_name(output_prefix.name + "_TTOTflag.csv"), data.ttot_flag)
    write_series_plain(output_prefix.with_name(output_prefix.name + "_VT.csv"), data.vt)


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------


def build_argparser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(description="Reference preprocessing for rsaToolbox v2.0.2")
    p.add_argument("--resp", type=Path, required=True, help="Path to *_Resp.csv")
    p.add_argument("--rr", type=Path, required=True, help="Path to *_RR.csv")
    p.add_argument(
        "--output-prefix",
        type=Path,
        required=True,
        help="Output prefix without suffixes, e.g. /tmp/participant_01_PB_9br",
    )
    return p


def main() -> None:
    args = build_argparser().parse_args()
    out = preprocess_vivologic_pair(args.resp, args.rr)
    write_rsatoolbox_input(args.output_prefix, out)
    print(f"Wrote rsaToolbox input files for prefix: {args.output_prefix}")


if __name__ == "__main__":
    main()
