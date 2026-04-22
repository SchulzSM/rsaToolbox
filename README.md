# rsaToolbox

Toolbox for analyzing respiration-corrected respiratory sinus arrhythmia (RSA) from interbeat intervals, respiration cycles, and tidal volume data.

---

## Background

Respiratory sinus arrhythmia (RSA) is a widely used index of cardiac vagal activity. However, RSA is substantially influenced by respiration rate and tidal volume.

This toolbox implements a method to correct within-individual RSA estimates for respiratory influences.

The approach is described in:

Schulz, S. M., Ayala, E., Dahme, B., & Ritz, T. (2009).
*A MATLAB toolbox for correcting within-individual effects of respiration rate and tidal volume on respiratory sinus arrhythmia during variable breathing.*
Behavior Research Methods, 41(4), 1121–1126.
https://doi.org/10.3758/BRM.41.4.1121

---

## Versioning

The rsaToolbox has evolved across multiple MATLAB-based releases and is currently being reimplemented in Python.

Published versions in this repository include:

* v1.4.9
* v2.0.0
* v2.0.1
* v2.0.2 (**current MATLAB version**)

The version described in the original publication corresponds to an early development stage and was not released as a standalone version.
Therefore, version v1.0.0 is not included.

Each MATLAB version is available as:

* MATLAB source code (`.m`)
* compiled Windows executable (32-bit)

A Python implementation is planned as version v3.x.

---

## Repository Structure

```text
versions/      → legacy MATLAB versions (source + executable)
python/        → ongoing Python reimplementation
examples/      → example datasets (raw + processed)
docs/          → manuals and documentation
```

---

## Installation

### MATLAB version

Requires MATLAB (tested with R2008a–R2010b).
Run scripts from the corresponding version directory.

---

### Executable version

Requires MATLAB Compiler Runtime (MCR):

* Version: **7.14.1 (MATLAB R2010b)**

The runtime is **not included** in this repository.

Older MCR versions may need to be obtained via MathWorks support or archived sources.

---

### Python version

Work in progress.
See documentation in `docs/`.

---

## Usage

The toolbox computes respiration-corrected RSA by modeling the relationship between:

* RSA
* tidal volume (VT)
* respiratory cycle duration (TTOT)

Typical workflow:

1. preprocess respiration and cardiac data
2. compute RSA and RSA/VT
3. model baseline respiratory effects
4. derive corrected vagal tone indices

For details, see documentation below.

---

## Reproducibility

This repository provides a fully reproducible preprocessing pipeline:

* raw example data
* generated preprocessing files
* Python reference implementation

These allow validation of preprocessing and independent reimplementation.

---

## Example Data

Example datasets are available in:

```text
examples/
```

They include:

* paced breathing data
* experimental data
* raw exports (`*_Resp.csv`, `*_RR.csv`)
* precomputed preprocessing outputs

These data are **not version-specific** and apply to all versions of rsaToolbox.

A full worked example is provided in:

```text
docs/worked_example.md
```

---

## Documentation

All documentation is located in:

```text
docs/
```

### Quickstart

* `docs/quickstart_example.md`
  Step-by-step introduction using the example dataset

---

### Worked Example

* `docs/worked_example.md`
  File-level explanation of preprocessing and synchronization

---

### Technical Manual

* `docs/manual_v2.0.2.md`
  Full workflow, batch processing, and interpretation

---

### Preprocessing Specification

* `docs/manual_preprocessing_spec.md`
  Formal definition of required input files and synchronization logic

---

### Python Reference Implementation

* `docs/python_reference_preprocessing.md`

A reference implementation of preprocessing logic is provided in:

```text
python/reference/rsa_manual_preprocessing_reference.py
```

This implementation:

* reproduces preprocessing behavior of the example dataset
* makes synchronization logic explicit
* serves as a basis for Python reimplementation (v3.x)

---

### Related Publications

* `docs/publications.md`

---

## Citation

If you use this software, please cite:

Schulz, S. M., Ayala, E., Dahme, B., & Ritz, T. (2009).
*A MATLAB toolbox for correcting within-individual effects of respiration rate and tidal volume on respiratory sinus arrhythmia during variable breathing.*
Behavior Research Methods, 41(4), 1121–1126.
https://doi.org/10.3758/BRM.41.4.1121

---

## License

GNU Lesser General Public License (LGPL), version 2.1 or later.
See LICENSE file.

---

## Credits

Thomas Ritz
Bernhard Dahme

for the scientific foundations and methodological contributions.

---

## Contact

Prof. Dr. Stefan M. Schulz
Trier University, Germany
Email: [stefan.m.schulz@uni-trier.de](mailto:stefan.m.schulz@uni-trier.de)

---

## Notes

This repository consolidates legacy MATLAB implementations and ongoing development, with a focus on transparency, reproducibility, and future extensibility.
