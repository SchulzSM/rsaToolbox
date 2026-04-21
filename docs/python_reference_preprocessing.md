# Python Reference Preprocessing for rsaToolbox v2.0.2

## Purpose

This document describes the Python reference implementation provided with this repository for generating rsaToolbox-compatible input files from exported respiration and cardiac data.

It is intended as:

* a validation tool for the example dataset
* a transparent reference for the preprocessing logic
* a starting point for a future Python-based reimplementation of rsaToolbox

---

## Files

The reference implementation consists of:

* `rsa_manual_preprocessing_reference.py`
* `rsa_manual_preprocessing_reference_README.md`

---

## Scope

The current reference implementation is designed primarily for the **VivoLogic/VivoSense-style export structure** used in the example dataset.

It reproduces the preprocessing behavior for paired files of the form:

* `*_Resp.csv`
* `*_RR.csv`

and generates the rsaToolbox-compatible files:

* `*_IBI.csv`
* `*_IBIflag.csv`
* `*_TTOT.csv`
* `*_TTOTflag.csv`
* `*_VT.csv`

---

## What the script currently reproduces

Using the example dataset, the reference implementation reproduces the generated preprocessing files for the VivoLogic case, including the following behaviors:

### TTOT

`TTOT.csv` starts with the **second** row of the respiratory export, i.e. with the first fully usable respiratory cycle.

### VT

`VT.csv` is computed as:

```text
VT = (ViVol + VeVol) / 2000
```

with the result stored in liters.

### IBI

`IBI.csv` is **not** a direct copy of the raw RR column.

Instead:

* the first IBI is computed as the interval from the first usable respiratory timestamp to the first following R-peak
* subsequent values follow the RR series in milliseconds

### IBIflag

The first partial interval is marked separately in `IBIflag.csv`.

---

## Why this matters

This reference implementation makes explicit a preprocessing step that is otherwise hidden inside the GUI-based import tools.

It therefore serves three purposes:

1. **Validation**
   Users can compare generated files against the provided example dataset.

2. **Transparency**
   The synchronization logic becomes inspectable and testable.

3. **Future migration**
   The code provides a concrete basis for the planned Python implementation of rsaToolbox.

---

## Recommended use

### For users of the example dataset

Use the script to verify that preprocessing works as expected for files such as:

```text
participant_01/pacedBreathing/vivologicExport/participant_01_PB_9br_Resp.csv
participant_01/pacedBreathing/vivologicExport/participant_01_PB_9br_RR.csv
```

Then compare the outputs with the already included generated files one folder above.

### For developers

Use the script as the reference behavior for:

* synchronization logic
* VT generation
* TTOT generation
* initial IBI alignment

---

## Limitations

The current script is a **reference implementation**, not yet a full replacement for rsaToolbox.

In particular:

* advanced artifact handling is not fully generalized
* generic non-Vivo signal preprocessing still requires explicit cycle detection and artifact logic
* the full GUI-based workflow of rsaToolbox is not reproduced

Accordingly, the script should be treated as a **documented preprocessing reference**, not yet as a complete production pipeline.

---

## Validation recommendation

Any future preprocessing implementation should be validated against the example dataset, especially:

```text
participant_01_PB_9br
```

A correct implementation should reproduce:

* `_TTOT.csv`
* `_VT.csv`
* `_IBI.csv`
* `_IBIflag.csv`
* `_TTOTflag.csv`

with matching values and alignment logic.

---

## Relationship to the documentation

This document complements:

* `docs/quickstart_example.md`
* `docs/worked_example.md`
* `docs/manual_v2.0.2.md`
* `docs/manual_preprocessing_spec.md`

Together, these files cover:

* basic usage
* worked examples
* technical preprocessing requirements
* a concrete Python reference implementation
