# rsaToolbox v2.0.2 – Manual Preprocessing Specification

## Purpose

This document specifies how rsaToolbox-compatible preprocessing files must be generated when raw data are **not** imported through the built-in VivoLogic/VivoSense batch import tools.

It is intended for:

* users working with data from other acquisition systems
* developers implementing preprocessing outside rsaToolbox
* future Python-based reimplementations
* validation of custom preprocessing pipelines

This specification defines the required output files, their alignment rules, and the minimum preprocessing logic needed to produce valid input for rsaToolbox.

For general software usage, batch processing, and output interpretation, see:

* `manual_v2.0.2.md`

For a file-level walkthrough of the included example dataset, see:

* `worked_example.md`

---

# 1. Overview

rsaToolbox does **not** operate directly on arbitrary raw physiological time series.

Instead, it expects a set of derived files that represent respiration-segmented input for breath-wise RSA analysis.

The required preprocessing outputs are:

```text
*_IBI.csv
*_IBIflag.csv
*_TTOT.csv
*_TTOTflag.csv
*_VT.csv
```

These files must be generated in a coordinated way.

The most important principle is:

> respiration defines the segmentation, and cardiac data must be aligned to that respiratory segmentation.

---

# 2. Two preprocessing routes

## 2.1 Automated route

If data were exported from compatible systems such as VivoLogic/VivoSense and the paired raw files are available as:

```text
*_Resp.csv
*_RR.csv
```

then the preferred route is to use the built-in import tools in rsaToolbox, for example:

```text
Tools → VivoLogic Data Import – v02
```

or

```text
Tools → VivoSense® Data Import – v02
```

This route is preferred because synchronization and transformation are handled automatically.

## 2.2 Manual route

If data come from other systems, preprocessing must be done externally.

In that case, the manually created `*_IBI.csv`, `*_IBIflag.csv`, `*_TTOT.csv`, `*_TTOTflag.csv`, and `*_VT.csv` files become the direct input for rsaToolbox.

This document specifies how they must be created.

---

# 3. Fundamental alignment principle

## 3.1 Respiration defines the analysis unit

The basic unit in rsaToolbox preprocessing is the **breath**.

This means that the output files are not simple time-series copies of the original signals. Instead, they are organized according to the sequence of usable respiratory cycles.

For each usable breath, the preprocessing must generate:

* one TTOT value
* one TTOT flag
* one VT value
* one IBI representation aligned to the breath sequence
* one IBI flag representation aligned to the same sequence

## 3.2 Shared temporal basis is mandatory

All preprocessing depends on correct temporal alignment between respiration and cardiac data.

The respiration and cardiac signals must therefore share:

* the same time base
* the same origin
* the same unit of time
* sufficient temporal precision

If these conditions are not met, rsaToolbox input files may still be generated, but the results will be physiologically incorrect.

## 3.3 Real clock time is not required

The actual calendar date is irrelevant.

What matters is that timing is internally consistent.

Thus, an artificial timestamp is acceptable, provided that:

* it is strictly increasing
* it preserves the true temporal spacing of events
* it is identical across respiration and cardiac representations

---

# 4. Input assumptions for manual preprocessing

A manual preprocessing workflow must begin from data that permit reconstruction of:

* respiratory cycle boundaries
* tidal volume per breath
* cardiac interbeat intervals relative to those respiratory cycles

At minimum, the following must be available:

## 4.1 Respiration input

The respiration input must allow determination of:

* inspiration onset times or equivalent cycle boundaries
* inspiratory and expiratory volume or a valid method to compute tidal volume
* total respiratory cycle duration per breath

## 4.2 Cardiac input

The cardiac input must allow determination of:

* R-peak times, or
* RR intervals plus a valid time origin from which R-peak times can be reconstructed

If only RR intervals are available, they must be convertible to a temporally ordered sequence of cardiac events.

---

# 5. Required output files

## 5.1 `*_TTOT.csv`

This file contains the total duration of each usable respiratory cycle.

### Definition

For breath `i`, let:

* `t_i` = onset time of breath `i`
* `t_(i+1)` = onset time of the next breath

Then:

```text
TTOT[i] = t_(i+1) - t_i
```

### Unit

* seconds

### Interpretation

TTOT represents the total respiratory cycle duration of a breath and is one of the central respiratory covariates in rsaToolbox.

### Important note

In the example dataset, TTOT begins with the **first fully usable respiratory cycle**, not necessarily with the first row of the original respiratory export.

Thus, manual preprocessing must determine the first valid breath and should not blindly copy all original rows.

---

## 5.2 `*_TTOTflag.csv`

This file contains a per-breath flag indicating whether the corresponding TTOT value should be treated as valid or invalid.

### Minimum requirement

A binary flag scheme is acceptable:

* `0` = valid breath
* `1` = invalid breath

### Causes for invalidity may include

* incomplete respiratory cycle
* corrupted respiration data
* missing cycle boundary
* impossible or implausible TTOT value

### Alignment rule

The `n`th entry in `TTOTflag.csv` must refer to the same breath as the `n`th entry in `TTOT.csv`.

---

## 5.3 `*_VT.csv`

This file contains tidal volume per breath.

### General definition

VT is the tidal volume associated with each usable breath.

### Example-dataset rule

For the included VivoLogic-style example data, VT is reproduced as:

```text
VT = (ViVol + VeVol) / 2000
```

with VT expressed in liters.

This relationship is directly validated by the example dataset and should be used when reproducing the provided example files.

### Unit

* liters

### Generalization

If another acquisition system is used, VT may be computed by another valid method, but the output must still represent one physiologically meaningful tidal-volume value per usable breath.

### Constraints

VT values should be:

* positive
* finite
* physiologically plausible

---

## 5.4 `*_IBI.csv`

This file contains the cardiac interbeat-interval representation aligned to the respiratory segmentation.

This is the most critical and least trivial output.

### Important warning

`IBI.csv` is **not** simply the raw RR column copied into a new file.

The example dataset shows explicitly that rsaToolbox preprocessing aligns cardiac information to the respiratory structure.

### Example-dataset behavior

In the example dataset:

* the first IBI value is a **partial interval**
* it is computed from the first usable breath start to the first following cardiac event
* subsequent values follow the RR sequence in milliseconds

This means that preprocessing is sensitive to where the respiratory segmentation begins.

### Practical specification

A valid manual pipeline must:

1. reconstruct the temporally ordered sequence of cardiac events
2. align that cardiac sequence to the breath sequence
3. generate IBI values in a way that is consistent with the respiratory segmentation

### Minimum unit requirement

IBI values must be written in:

* milliseconds

### Recommended implementation rule

If reproducing the example-dataset behavior:

1. identify the timestamp of the first usable breath
2. identify the first cardiac event after that breath start
3. compute the first partial IBI as:

```text
first_IBI = first_R_peak_after_breath_start - first_usable_breath_start
```

4. express that value in milliseconds
5. then continue with subsequent RR intervals in milliseconds

### Generalization warning

For non-Vivo datasets, the exact IBI-construction rule must preserve the same physiological meaning: cardiac timing must be represented relative to respiratory segmentation, not independently of it.

---

## 5.5 `*_IBIflag.csv`

This file contains per-entry flags for the IBI representation.

### Minimum requirement

A binary flag scheme is acceptable:

* `0` = standard/valid IBI entry
* `1` = special or invalid IBI entry

### Example-dataset behavior

In the example dataset, the first partial IBI is flagged separately.

This means the first value in `IBIflag.csv` may differ from the remaining values.

### Alignment rule

The `n`th entry in `IBIflag.csv` must correspond exactly to the `n`th entry in `IBI.csv`.

---

# 6. Temporal synchronization specification

## 6.1 Required properties

The respiration and cardiac representations used for preprocessing must satisfy all of the following:

* timestamps are strictly increasing
* timestamps refer to the same temporal reference frame
* there is no unknown offset between respiration and cardiac timing
* time units are consistent
* rounding errors do not distort event ordering

## 6.2 Artificial timestamps

If the source system does not provide absolute timestamps, an artificial time axis may be created.

Such an artificial time axis is valid only if:

* it is created identically for both respiration and cardiac data
* it preserves the original event intervals exactly
* it allows exact synchronization of respiratory and cardiac events

## 6.3 Acceptable artificial-time construction

A common valid strategy is:

1. choose an arbitrary origin, for example:

   * `2000-01-01 00:00:00.000`
2. reconstruct all subsequent event times by cumulative addition of measured intervals
3. use the same origin and cumulative logic for both respiration and cardiac representations

## 6.4 Unacceptable synchronization shortcuts

The following are not acceptable:

* using independent artificial clocks for respiration and cardiac data
* rescaling one signal without rescaling the other identically
* copying RR intervals without reconstructing their timing
* assigning timestamps by row number only when true temporal spacing differs

---

# 7. Breath detection and usability

## 7.1 Breath definition

A breath used for rsaToolbox preprocessing is typically defined from one inspiration onset to the next.

The preprocessing workflow must therefore identify a consistent sequence of breath boundaries.

## 7.2 Usable breath sequence

Not every detected breath should automatically be included.

A breath may need to be excluded if:

* the cycle is incomplete
* required variables are missing
* there is severe artifact
* cycle duration is implausible
* synchronization with cardiac timing is not possible

Only the usable breath sequence should define the final aligned outputs.

## 7.3 Consequence for file lengths

Because unusable breaths may be removed, the output length may differ from the raw input row count.

The final output files must all have the same length and refer to the same set of usable breaths.

---

# 8. Units and formatting

## 8.1 Required units

* `TTOT.csv` → seconds
* `VT.csv` → liters
* `IBI.csv` → milliseconds

## 8.2 Numeric formatting

Values should be stored in plain numeric form without extra headers unless a downstream workflow explicitly expects headers.

The formatting should be consistent across files.

## 8.3 Missing data

If missing values are used in preprocessing, they must be handled consistently and must not silently break row alignment across files.

A flag-based exclusion scheme is strongly preferred over silently dropping rows in only one file.

---

# 9. Alignment constraints across files

The generated files must satisfy all of the following:

1. identical row count across:

   * `IBI.csv`
   * `IBIflag.csv`
   * `TTOT.csv`
   * `TTOTflag.csv`
   * `VT.csv`

2. row `n` in every file refers to the same breath

3. no file may contain extra retained breaths that are absent from the others

4. flags must refer to the values in the same row position

This is a hard requirement.

---

# 10. Validation checklist

Before using manually generated files in rsaToolbox, verify the following.

## 10.1 Structural validation

* all required files exist
* filenames are matched correctly
* row counts are identical
* numeric formats are readable

## 10.2 Unit validation

* TTOT in seconds
* VT in liters
* IBI in milliseconds

## 10.3 Physiological plausibility

* TTOT > 0
* VT > 0
* IBI > 0
* values lie in plausible ranges for the target population

## 10.4 Synchronization validation

* the first usable breath occurs at the expected time
* the first IBI is aligned relative to breath onset
* the generated output is consistent with the intended respiratory segmentation

## 10.5 Example-based validation

If reproducing the example dataset, compare generated outputs against the included example files, especially for:

```text
participant_01_PB_9br
```

A correct implementation should reproduce the same logic for:

* `*_TTOT.csv`
* `*_TTOTflag.csv`
* `*_VT.csv`
* `*_IBI.csv`
* `*_IBIflag.csv`

---

# 11. Common failure modes

## 11.1 Copying RR directly into IBI

This is incorrect unless it exactly reproduces the respiratory alignment logic, which in general it does not.

## 11.2 Using inconsistent time origins

If respiration and cardiac data do not share the same origin, synchronization is invalid.

## 11.3 Ignoring unusable first breath rows

The example dataset shows that the first row of a raw respiratory export may not become the first row of the generated TTOT/VT sequence.

## 11.4 Flag files not matching the value files

Misaligned flags can silently invalidate downstream interpretation.

## 11.5 Selective row deletion

Deleting rows from one file but not the others breaks breath alignment.

---

# 12. Recommended implementation strategy

For external preprocessing, the recommended logic is:

1. reconstruct or validate a shared time base
2. detect respiratory cycle boundaries
3. determine the first usable breath
4. compute TTOT per usable breath
5. compute VT per usable breath
6. reconstruct cardiac event timing
7. align cardiac timing to the usable breath sequence
8. generate the IBI representation in milliseconds
9. generate flags
10. verify row-by-row alignment across all files

---

# 13. Relation to the Python reference implementation

The repository includes a Python reference implementation documenting the preprocessing behavior for the example dataset.

That implementation should be treated as a practical companion to this specification.

This specification is normative at the conceptual level; the Python reference is operational at the example level.

See:

* `python_reference_preprocessing.md`

---

# 14. Final recommendation

Whenever possible, use the built-in import tools of rsaToolbox for compatible VivoLogic/VivoSense exports.

Manual preprocessing should be used only when necessary and should always be validated against a known-good reference dataset.

The included example data are provided for exactly that purpose.
