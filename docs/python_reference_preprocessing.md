# Python Reference Preprocessing for rsaToolbox v2.0.2

## Purpose

This document describes the Python reference implementation provided in this repository for generating rsaToolbox-compatible preprocessing files.

It serves as:

* a **validation tool** for the example dataset
* a **transparent reference implementation** of preprocessing logic
* a **starting point** for future Python-based versions of rsaToolbox (v3.x)

This document complements:

* `manual_preprocessing_spec.md` → formal specification
* `worked_example.md` → file-level walkthrough
* `manual_v2.0.2.md` → full workflow

---

# 1. Scope

The current Python reference implementation is designed for:

* VivoLogic / VivoSense-style export data
* paired files:

  ```text
  *_Resp.csv
  *_RR.csv
  ```

It reproduces the preprocessing behavior observed in the example dataset.

---

# 2. Input and Output

## 2.1 Input

The script expects:

* respiration file: `*_Resp.csv`
* cardiac file: `*_RR.csv`

These must:

* share the same time base
* be temporally aligned
* follow the column structure used in the example dataset

---

## 2.2 Output

The script generates the required rsaToolbox input files:

```text
*_IBI.csv
*_IBIflag.csv
*_TTOT.csv
*_TTOTflag.csv
*_VT.csv
```

These outputs are **directly compatible** with rsaToolbox.

---

# 3. Key preprocessing logic

The implementation follows the behavior reconstructed from the example dataset.

---

## 3.1 TTOT generation

```text
TTOT = respiratory cycle duration
```

Behavior:

* derived from respiration cycles
* starts with the **first fully usable breath**
* corresponds to the second row in the example export

---

## 3.2 VT generation

For the example dataset:

```text
VT = (ViVol + VeVol) / 2000
```

Unit:

* liters

This formula is validated directly against the example files and should reproduce identical values.

---

## 3.3 IBI generation

This is the most critical step.

### Important

IBI is **not copied** from the RR column.

---

### Example-dataset behavior

The script implements:

1. identify first usable breath start
2. find first R-peak after that time
3. compute first IBI as:

```text
first_IBI = first_R_peak_after_breath_start − breath_start
```

4. convert to milliseconds

5. append subsequent RR intervals (converted to ms)

---

### Result

* first IBI value is a **partial interval**
* remaining values follow RR sequence

---

## 3.4 IBIflag generation

* first value flagged (partial interval)
* subsequent values unflagged

---

## 3.5 TTOTflag generation

Basic implementation:

* all valid breaths → flag = 0
* invalid cycles → flag = 1

(Current reference implementation uses a minimal scheme.)

---

# 4. Why this implementation matters

The rsaToolbox preprocessing is normally hidden inside GUI-based import tools.

This reference implementation makes explicit:

* synchronization logic
* breath-based segmentation
* cardiac alignment

This is essential for:

* debugging
* validation
* reproducibility
* reimplementation

---

# 5. Validation using the example dataset

The script should be tested against:

```text
participant_01_PB_9br
```

Validation steps:

1. run the script on:

   ```text
   *_Resp.csv
   *_RR.csv
   ```
2. compare outputs with provided files:

   ```text
   *_TTOT.csv
   *_VT.csv
   *_IBI.csv
   *_IBIflag.csv
   *_TTOTflag.csv
   ```

Expected:

* identical TTOT values
* identical VT values
* identical IBI structure (including first partial interval)

---

# 6. Limitations

This implementation is a **reference**, not a full production pipeline.

Limitations include:

* simplified artifact handling
* minimal flag logic
* no advanced quality control
* no GUI integration

---

# 7. Extension to non-Vivo data

For other acquisition systems, additional steps are required:

* breath detection from continuous respiration signal
* robust artifact detection
* reconstruction of cardiac event timing
* careful synchronization

These requirements are formally defined in:

* `manual_preprocessing_spec.md`

---

# 8. Relationship to future development

This reference implementation provides:

* a validated preprocessing core
* a reproducible baseline
* a bridge from MATLAB to Python

It is intended to support development of:

```text
rsaToolbox v3.x (Python)
```

---

# 9. Recommended usage

Use this implementation:

✔ to validate preprocessing
✔ to understand synchronization
✔ to reproduce example outputs
✔ as a starting point for custom pipelines

Do not use it (yet):

❌ as a drop-in replacement for rsaToolbox
❌ without validating outputs

---

# 10. Practical workflow

Recommended workflow:

```text
Example data → Python reference → compare with example outputs → run rsaToolbox
```

This ensures:

* correct preprocessing
* correct alignment
* reproducible results

---

# 11. Final note

The most important takeaway is:

> Preprocessing in rsaToolbox is defined by respiratory segmentation and cardiac alignment, not by raw signal transformation.

The Python reference implementation makes this principle explicit and testable.
