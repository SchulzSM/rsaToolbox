# Worked Example: Preprocessing and Synchronization in rsaToolbox v2.0.2

This document provides a detailed, file-level walkthrough of how raw respiration and cardiac data are transformed into rsaToolbox input files.

It uses the included example dataset and demonstrates:

* how `*_Resp.csv` and `*_RR.csv` relate to generated files
* how synchronization is performed
* how key variables (TTOT, VT, IBI) are derived

This example is essential for understanding and validating preprocessing.

---

# 1. Example Selection

We use the following dataset:

```text
examples/participant_01/pacedBreathing/vivologicExport/
  participant_01_PB_9br_Resp.csv
  participant_01_PB_9br_RR.csv
```

The corresponding generated files are located one folder above:

```text
examples/participant_01/pacedBreathing/
  participant_01_PB_9br_IBI.csv
  participant_01_PB_9br_IBIflag.csv
  participant_01_PB_9br_TTOT.csv
  participant_01_PB_9br_TTOTflag.csv
  participant_01_PB_9br_VT.csv
```

---

# 2. Raw Data Inspection

## 2.1 Respiratory File

Excerpt:

```text
INDEX, DATE, TIME, ViVol, VeVol, Tt
1, ..., ..., 785, 485, 11.48
2, ..., ..., 318, 296, 4.20
3, ..., ..., 518, 728, 4.74
4, ..., ..., 521, 139, 3.78
```

Key variables:

* `ViVol` → inspiratory volume
* `VeVol` → expiratory volume
* `Tt` → total respiratory cycle duration

---

## 2.2 Cardiac File

Excerpt:

```text
INDEX, DATE, TIME, RR
1, ..., ..., 1.013
2, ..., ..., 0.880
3, ..., ..., 0.892
4, ..., ..., 1.099
```

Key variable:

* `RR` → interbeat interval in seconds

---

# 3. TTOT: Respiratory Cycle Duration

Generated file:

```text
participant_01_PB_9br_TTOT.csv
```

First values:

```text
4.20
4.74
3.78
4.30
```

### Key observation

👉 TTOT starts from the **second row** of the respiratory export.

### Interpretation

* The first respiratory row is not used directly
* TTOT is defined between **successive inspiration onsets**

---

# 4. VT: Tidal Volume

Generated file:

```text
participant_01_PB_9br_VT.csv
```

First values:

```text
0.307
0.623
0.330
```

### Validation

Using raw data:

```text
VT = (ViVol + VeVol) / 2000
```

Example:

```text
(318 + 296) / 2000 = 0.307 L
```

👉 VT can be exactly reproduced from raw data.

---

# 5. IBI: Cardiac Alignment

Generated file:

```text
participant_01_PB_9br_IBI.csv
```

First values:

```text
757
1045
1009
```

---

## 5.1 Critical Observation

👉 IBI is NOT a direct copy of RR values.

---

## 5.2 First IBI Value

The first value (757 ms) corresponds to:

```text
time(first R-peak after breath start)
− time(breath start)
```

This is a **partial interval**, not a full RR interval.

---

## 5.3 Subsequent Values

After the first value:

* IBI follows RR values
* converted to milliseconds

---

## 5.4 Interpretation

The preprocessing:

1. aligns cardiac data to respiration
2. segments heartbeats by breathing cycles
3. expresses IBI relative to breath structure

👉 This is the key synchronization mechanism.

---

# 6. IBIflag

Generated file:

```text
participant_01_PB_9br_IBIflag.csv
```

Typical pattern:

* first value flagged (partial interval)
* subsequent values unflagged

---

# 7. Synchronization Logic (Summary)

From this example, we can reconstruct the implicit rules:

---

## Rule 1: Respiration defines segmentation

* each breath is a unit
* TTOT and VT are computed per breath

---

## Rule 2: Cardiac data is mapped onto respiration

* heartbeats are aligned to breath boundaries
* IBI is expressed relative to respiration

---

## Rule 3: First interval is special

* partial interval from breath start to next R-peak
* must be flagged

---

## Rule 4: Output is breath-aligned

All files:

```text
IBI
IBIflag
TTOT
TTOTflag
VT
```

refer to the same breath sequence.

---

# 8. Why this matters

This example reveals a critical property:

👉 rsaToolbox preprocessing is NOT a simple transformation.

It performs:

* synchronization
* segmentation
* physiological alignment

---

# 9. Common Misinterpretations

### ❌ “IBI = RR”

Incorrect — IBI is aligned to respiration.

### ❌ “First row is always used”

Incorrect — first breath may be excluded or transformed.

### ❌ “Time doesn’t matter”

Incorrect — synchronization is essential.

---

# 10. Validation Workflow

To validate preprocessing:

1. open raw `*_Resp.csv`
2. compute VT manually
3. compare with `*_VT.csv`
4. inspect TTOT alignment
5. verify IBI first value logic

---

# 11. Implications for Users

### If using VivoLogic/VivoSense

✔ use automated import
✔ no need to implement this logic manually

---

### If using other systems

⚠️ you MUST reproduce this behavior:

* breath segmentation
* cardiac alignment
* partial interval handling

---

# 12. Relation to Other Docs

This document complements:

* `quickstart_example.md` → how to run
* `manual_v2.0.2.md` → full workflow
* `manual_preprocessing_spec.md` → formal definition
* `python_reference_preprocessing.md` → implementation

---

# 13. Key Takeaway

The most important insight from this worked example is:

> rsaToolbox preprocessing aligns cardiac and respiratory data at the level of individual breaths, not at the level of raw signals.

Understanding this principle is essential for:

* correct usage
* debugging
* reimplementation
