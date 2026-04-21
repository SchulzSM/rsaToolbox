# rsaToolbox v2.0.2 – Technical Manual

## Overview

This manual describes the complete workflow for analyzing respiration-corrected respiratory sinus arrhythmia (RSA) using rsaToolbox v2.0.2.

It is intended for:

* lab staff
* advanced users
* reproducible analysis pipelines

The toolbox processes respiration and cardiac data to compute:

* RSA (peak-valley method)
* RSA normalized by tidal volume (RSA/VT)
* breath-by-breath physiological measures

---

# 1. Conceptual Framework

rsaToolbox operates on **breath-aligned data**.

This means:

* respiration defines segmentation
* cardiac data is mapped onto respiration
* all outputs are computed per breath

⚠️ The toolbox does **not** internally synchronize signals
→ correct preprocessing is essential

---

# 2. Input Data

## 2.1 Raw Input (preferred)

From systems such as VivoLogic/VivoSense:

```text
*_Resp.csv
*_RR.csv
```

These must:

* share identical timestamps
* have consistent structure
* originate from the same recording system

---

## 2.2 Preprocessed Input (manual pipeline)

Alternatively, the toolbox accepts:

```text
*_IBI.csv
*_IBIflag.csv
*_TTOT.csv
*_TTOTflag.csv
*_VT.csv
```

These must:

* be aligned 1:1
* represent identical breath sequences

---

# 3. Preprocessing Pipelines

## 3.1 Automated Pipeline (recommended)

Use:

```text
Tools → VivoLogic Data Import – v02
```

This step:

* synchronizes RR and respiration
* detects respiratory cycles
* computes TTOT and VT
* aligns cardiac data to respiration
* generates all required input files

✔ preferred workflow
✔ minimizes errors

---

## 3.2 Manual Pipeline

Required if:

* data come from other systems
* custom preprocessing is needed

Must implement:

* breath detection
* TTOT computation
* VT computation
* cardiac alignment
* flag generation

See:

* `manual_preprocessing_spec.md`
* `python_reference_preprocessing.md`

---

# 4. Time Synchronization

## 4.1 Fundamental requirement

RR and respiration data must:

* share identical time base
* start at the same time
* have consistent sampling

---

## 4.2 Artificial time

Real clock time is not required.

Only important:

* relative timing
* consistency across signals

---

## 4.3 Failure consequences

If synchronization is incorrect:

* RSA estimates are invalid
* errors may not be detected
* results may appear plausible but be wrong

---

# 5. Batch Processing

## 5.1 Preparation

Create batch folder:

```text
Batch_01/
```

Place inside:

* all `*_Resp.csv`
* all `*_RR.csv`

⚠️ No subfolders allowed

---

## 5.2 Recommended batch size

* ~10 participants
* larger batches possible depending on memory

---

## 5.3 Import

```text
Tools → VivoLogic Data Import – v02
```

Outputs:

```text
data_generated_for_rsaToolbox/
```

---

## 5.4 Validation

Check:

* number of generated files
* `errorLog.txt`
* completeness of batch

---

# 6. Configuration Options

## 6.1 Standard settings

* Infant Option → ON
* Split Filenames → ON
* Expert Mode → OFF

---

## 6.2 Infant vs Adult Mode

### Infant mode (recommended)

* no calibration required
* direct RSA computation

---

### Adult mode

Requires:

* calibration procedure
* estimation of intercept and slope

This is not required for standard workflows.

---

## 6.3 Expert Mode

Provides advanced options:

* artifact handling
* quality thresholds

⚠️ Use only if fully understood

---

# 7. RSA Computation

Run:

```text
Batch Processing → Compute Simple RSA and RSA/VT
```

Input:

* `data_generated_for_rsaToolbox/`

---

# 8. Output Files

## 8.1 OverviewPerInputFile.txt

Contains one row per dataset.

Key variables:

* mean RSA [ms]
* mean RSA/VT [ms/l]
* mean VT [l]
* mean TTOT [s]

---

## 8.2 OutputPerInputFilePerBreath.txt

Contains breath-level data:

* RSA
* RSA/VT
* TTOT
* VT
* HR
* flags

---

# 9. Data Quality and Flags

## 9.1 Key indicators

* `nob` → number of breaths
* excluded via flag → artifacts
* failed PVC → invalid RSA patterns

---

## 9.2 Interpretation

* always interpret relative to total breaths
* high exclusion rates indicate data issues

---

# 10. Output Interpretation

## 10.1 RSA

* traditional peak-valley measure
* sensitive to respiration

---

## 10.2 RSA/VT

* normalized by tidal volume
* more robust estimate of vagal tone

---

## 10.3 TTOT

* reflects respiration rate

---

# 11. Postprocessing

Typical workflow:

1. open `.txt` files in Excel
2. import as tab-delimited
3. save as `.xlsx`
4. merge datasets if needed

---

## 11.1 Episode structure

In paced breathing:

* ~140 rows per episode
* ordering may be alphabetical

⚠️ Verify correct episode mapping

---

## 11.2 Further analysis

Possible tools:

* Excel
* SPSS
* R
* Python

---

# 12. Common Errors (CAVE)

⚠️ Incorrect timestamps
⚠️ mismatched file pairs
⚠️ wrong file types
⚠️ inconsistent column structure
⚠️ missing data

Important:

👉 The toolbox may NOT stop with an explicit error

---

# 13. Debugging Strategy

If results are unexpected:

1. check raw files
2. verify timestamps
3. inspect `errorLog.txt`
4. reduce batch size
5. re-run processing

---

# 14. Version Notes

* v2.0.0 → start of 2.x series
* v2.0.1 → improved artifact handling
* v2.0.2 → stable final MATLAB release

---

# 15. Best Practice Summary

✔ use automated import whenever possible
✔ verify synchronization
✔ inspect outputs manually
✔ keep batch sizes manageable
✔ document preprocessing

---

# 16. Limitations

* no automatic error validation
* GUI-based workflow
* limited automation

---

# 17. Future Direction

Future development:

* Python implementation (v3.x)
* improved automation
* reproducible pipelines

---

# 18. References

See:

* `publications.md`
* original publication (2009)

---

# 19. Final Remark

Correct preprocessing and synchronization are the most critical steps in using rsaToolbox.

All downstream results depend on them.
