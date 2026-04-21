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
* v2.0.2 (current MATLAB version)

The version described in the original publication (Schulz et al., 2009) corresponds to an early development stage and was not released as a standalone version.
Therefore, version v1.0.0 is not included in this repository.

Each MATLAB version is available both as source code (`.m` files) and as a compiled Windows executable (32-bit).

A future Python implementation is planned as version v3.0.0.

---

## Repository Structure

This repository contains multiple implementations and versions of the rsaToolbox:

* `matlab/` – original MATLAB implementation
* `executable/` – compiled standalone version (requires MATLAB Runtime)
* `python/` – ongoing Python reimplementation
* `examples/` – example datasets for testing and demonstration
* `docs/` – manuals and additional documentation

---

## Installation

### MATLAB version

Requires MATLAB (tested with R2008a–R2010b).
Run scripts from the `matlab/` directory.

### Executable version

1. Install MATLAB Compiler Runtime (MCR)
2. Run the executable in `executable/`

### Python version

(Work in progress)
Instructions will be added as development progresses.

---

## Usage

The toolbox computes respiration-corrected RSA by modeling the relationship between RSA, tidal volume, and respiratory cycle time.

Typical workflow:

1. Compute RSA from interbeat intervals
2. Normalize RSA by tidal volume
3. Estimate baseline relationship with respiratory cycle time
4. Compute deviations as indices of vagal tone changes

For detailed usage instructions, see the documentation in the `docs/` folder.

---

## Example Data

Example datasets are provided in the `examples/` directory:

* paced breathing data
* experimental data

These can be used to reproduce analyses and test functionality.

---

## Citation

If you use this software, please cite:

Schulz, S. M., Ayala, E., Dahme, B., & Ritz, T. (2009).
*A MATLAB toolbox for correcting within-individual effects of respiration rate and tidal volume on respiratory sinus arrhythmia during variable breathing.*
Behavior Research Methods, 41(4), 1121–1126.
https://doi.org/10.3758/BRM.41.4.1121

---

## Related Publications

The rsaToolbox and its underlying methodology have been used and cited in a range of psychophysiological studies.

### Methodological and Core Work

* Schulz, S. M., Ayala, E., Dahme, B., & Ritz, T. (2009).
  *A MATLAB toolbox for correcting within-individual effects of respiration rate and tidal volume on respiratory sinus arrhythmia during variable breathing.*
  Behavior Research Methods, 41(4), 1121–1126. https://doi.org/10.3758/BRM.41.4.1121

* Ritz, T., Bosquet Enlow, M., Schulz, S. M., et al. (2012).
  *Respiratory sinus arrhythmia as an index of vagal activity during stress in infants: respiratory influences and their control.*
  PLoS ONE, 7(12), e52729.

---

### Studies involving the authors

* Ritz, T., Schulz, S. M., Rosenfield, D., et al. (2020).
  *Cardiac sympathetic activation and parasympathetic withdrawal during psychosocial stress exposure in 6-month-old infants.*
  Psychophysiology.

* Cowell, W. J., et al. (2021).
  *Maternal pregnancy cortisol and parasympathetic responsivity to stress in infants.*
  Developmental Psychobiology.

* Cruciani, G., Cavicchioli, M., Tanzilli, G., Tanzilli, A., Lingiardi, V., & Galli, F. (2023).
  *Heart rate variability alterations in takotsubo syndrome: a systematic review and meta-analysis.*
  Scientific Reports.

---

### Broader Applications and Related Work

* Laborde, S., Mosley, E., & Thayer, J. F. (2017).
  *Heart rate variability and cardiac vagal tone in psychophysiological research.*
  Frontiers in Psychology.

* Quigley, K. S., et al. (2024).
  *Publication guidelines for HRV studies in psychophysiology.*
  Psychophysiology.

* Iwabe, T., et al. (2025).
  *Slow-paced breathing reduces anxiety and enhances alpha asymmetry.*
  Frontiers in Human Neuroscience.

Additional studies applying respiration-corrected RSA approaches can be found throughout the psychophysiological literature.

---

## License

This project is licensed under the GNU Lesser General Public License (LGPL), version 2.1 or later.
See the LICENSE file for details.

---

## Credits

Special thanks to Thomas Ritz and Bernhard Dahme for developing the scientific groundwork and underlying algorithm, as well as for valuable discussions and contributions.

---

## Contact

Dr. Stefan M. Schulz
University of Würzburg, Germany
Email: [schulz@psychologie.uni-wuerzburg.de](mailto:schulz@psychologie.uni-wuerzburg.de)

---

## Notes

This repository consolidates the original toolbox and ongoing developments, including future extensions and reimplementations.
