# Python reference preprocessing for rsaToolbox v2.0.2

This reference implementation is based on the behavior visible in the provided
example dataset and is meant to support documentation, validation, and future
Python reimplementation work.

## What it does reliably

For VivoLogic-style exports (`*_Resp.csv`, `*_RR.csv`), it reproduces the
observable preprocessing rules from the example data:

- `TTOT.csv` starts with the second raw respiratory row
- `VT.csv` is computed as `(ViVol + VeVol) / 2000` in liters
- `IBI.csv` starts with the partial interval from the first usable breath start
  to the first following R-peak; subsequent values are RR values in ms
- `IBIflag.csv` marks only the first partial interval with `1`
- `TTOTflag.csv` defaults to `0`

## Important limitation

This file is a **reference implementation**, not a claim of full bit-identical
reproduction of every internal rsaToolbox import feature for every possible
input source.

In particular, for non-Vivo raw data you still need to define:

- how inspiration onsets are detected
- how breath artifacts are flagged
- how beat artifacts are flagged

The included generic helper functions are meant to support that manual pipeline.

## Example usage

```bash
python rsa_manual_preprocessing_reference.py \
  --resp "/path/to/participant_01_PB_9br_Resp.csv" \
  --rr "/path/to/participant_01_PB_9br_RR.csv" \
  --output-prefix "/path/to/out/participant_01_PB_9br"
```

This writes:

- `participant_01_PB_9br_IBI.csv`
- `participant_01_PB_9br_IBIflag.csv`
- `participant_01_PB_9br_TTOT.csv`
- `participant_01_PB_9br_TTOTflag.csv`
- `participant_01_PB_9br_VT.csv`

## Recommended validation

Validate against the shipped example dataset, especially:

- `participant_01/pacedBreathing/participant_01_PB_9br_*`


