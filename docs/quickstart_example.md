# rsaToolbox v2.0.2 – Quickstart with the Example Dataset

This quickstart shows how to process the included example data with **rsaToolbox v2.0.2**.

It is intended for new users who want to:

* understand the folder structure
* run the automated preprocessing pipeline
* generate RSA and RSA/VT output files
* compare their results with the example outputs already included in the repository

For detailed background, synchronization rules, and manual preprocessing, see the other documents in `docs/`.

---

## 1. What the example dataset contains

The example data are organized by participant. Each participant has two analysis domains:

* `pacedBreathing/`
* `experimentalData/`

Inside each of these folders there is a subfolder:

* `vivologicExport/`

The `vivologicExport/` folders contain the original exported input files:

* `*_Resp.csv`
* `*_RR.csv`

One directory level above, the example dataset also contains already generated rsaToolbox input files such as:

* `*_IBI.csv`
* `*_IBIflag.csv`
* `*_TTOT.csv`
* `*_TTOTflag.csv`
* `*_VT.csv`

These precomputed files are included as a reference for validation.

---

## 2. Recommended first example

Start with one paced-breathing file pair, for example:

```text
examples/participant_01/pacedBreathing/vivologicExport/
  participant_01_PB_9br_Resp.csv
  participant_01_PB_9br_RR.csv
```

This is a good first example because it is small, clean, and its generated rsaToolbox input files are already available one folder above for comparison.

---

## 3. Before you start

### Software

You need:

* `rsaToolbox_v2.0.2.exe`
* MATLAB Compiler Runtime (MCR) **7.14.1** (MATLAB R2010b)

The MCR is required for the executable but is **not included** in the repository.

### Recommended setup

For this quickstart, create a temporary working folder on your local computer, for example:

```text
C:\rsaToolbox\Batch_Example\
```

---

## 4. The most important rule: time synchronization

The rsaToolbox depends on correct temporal alignment between respiration and cardiac data.

For the included example data, this is already handled correctly because the `*_Resp.csv` and `*_RR.csv` files in `vivologicExport/` were exported on the same time base.

That means:

* the timestamps in the respiratory and cardiac files match
* the automated import tool can generate the rsaToolbox input files correctly
* no manual synchronization is needed for this example

For other datasets, this may not be true. In that case, see:

* `docs/manual_preprocessing_spec.md`
* `docs/python_reference_preprocessing.md`

---

## 5. Prepare the batch folder

Copy the following files into a single local batch folder:

* `participant_01_PB_9br_Resp.csv`
* `participant_01_PB_9br_RR.csv`

Important:

* both files must be in the **same folder**
* they must **not** be placed in subfolders
* file naming must remain unchanged

If you want, you may copy several matching `*_Resp.csv` and `*_RR.csv` pairs into the same batch folder. For first use, one pair is enough.

---

## 6. Start rsaToolbox

Launch:

```text
rsaToolbox_v2.0.2.exe
```

When the program opens, check the version shown in the Event Monitor.

You should confirm that you are running:

```text
rsaToolbox v2.0.2
```

---

## 7. Set the options

Before importing data, set the following options:

### Required settings

* `Options → Infant Option` → **ON**
* `Options → Split Filenames` → select
  `1 – every place that is not a letter or number`
* `Options → Expert Mode` → **OFF**

These are the standard settings for routine processing.

Notes:

* The **Infant Option** is recommended for the standard workflow.
* **Expert Mode** should remain off unless you explicitly need advanced handling options.
* The same settings should be used consistently within a dataset.

---

## 8. Import the raw files

For the example dataset, use the automated import workflow.

Go to:

```text
Tools → VivoLogic Data Import – v02
```

Then:

1. navigate to your local batch folder
2. select one of the files
3. the toolbox will process all matching files in that folder

After import, the toolbox will create a new folder inside your batch folder:

```text
data_generated_for_rsaToolbox/
```

---

## 9. Check the generated files

Inside `data_generated_for_rsaToolbox/`, you should see files such as:

* `*_IBI.csv`
* `*_IBIflag.csv`
* `*_TTOT.csv`
* `*_TTOTflag.csv`
* `*_VT.csv`

You should also see log files such as:

* `description.txt`
* `errorLog.txt`

### What to check

Before continuing:

* confirm that the expected files were generated
* open `errorLog.txt`
* check for import problems
* verify that all file pairs were processed

Important: the toolbox may not always stop with an obvious warning if one file pair fails. Always inspect the generated output carefully.

---

## 10. Compute RSA and RSA/VT

Now run the standard analysis.

Go to:

```text
Batch Processing → Compute Simple RSA and RSA/VT
```

Then:

1. open the folder `data_generated_for_rsaToolbox/`
2. select one of the generated files
3. the toolbox will process all relevant files in that folder

If a pop-up appears asking for a quality criterion, you have probably activated Expert Mode by accident.
In that case, either:

* turn Expert Mode off and start again, or
* choose the standard option equivalent to the default workflow

Under normal quickstart use, **no pop-up should appear**.

---

## 11. Output files

The main output files are:

* `OverviewPerInputFile.txt`
* `OutputPerInputFilePerBreath.txt`

These can be opened in Excel using tab-delimited import.

A convenient workflow is:

1. open each `.txt` file in Excel
2. import as **tab-delimited**
3. save as `.xlsx`

---

## 12. What the outputs mean

### OverviewPerInputFile

This file contains one summary row per dataset.

The most important columns are:

* **mean RSA [ms] - meeting quality criteria**
  traditional RSA estimate

* **mean RSA/VT [ms/l] - meeting quality criteria**
  RSA adjusted for tidal volume

* **mean VT [l] - meeting quality criteria**
  mean tidal volume

* **mean TTOT [s] - meeting quality criteria**
  mean total respiratory cycle duration

For many applications, **RSA/VT** is the more informative variable because it adjusts RSA for breathing volume.

### OutputPerInputFilePerBreath

This file contains breath-by-breath values, including:

* RSA
* RSA/VT
* TTOT
* VT
* HR
* data-quality flags

This file is especially useful for:

* detailed inspection
* later residualization by TTOT
* debugging unexpected results

---

## 13. Validate against the included example outputs

The repository already contains generated preprocessing files for the example dataset.

After import, compare your generated files with the included example files one folder above the corresponding `vivologicExport/` directory.

For example, for:

```text
participant_01_PB_9br
```

you can compare your generated files with:

* `participant_01_PB_9br_IBI.csv`
* `participant_01_PB_9br_IBIflag.csv`
* `participant_01_PB_9br_TTOT.csv`
* `participant_01_PB_9br_TTOTflag.csv`
* `participant_01_PB_9br_VT.csv`

This is the quickest way to confirm that preprocessing is working correctly.

---

## 14. What you should notice in the example

When inspecting the example outputs, a few details are important:

### TTOT

`TTOT.csv` begins with the first fully usable respiratory cycle, not simply with the first row of the raw respiratory export.

### VT

`VT.csv` can be reproduced directly from the respiratory export as:

```text
VT = (ViVol + VeVol) / 2000
```

with VT in liters.

### IBI

`IBI.csv` is **not** just a copy of the raw RR values.
It is aligned to the respiratory segmentation used by the importer.

This is exactly why the automated import step is recommended whenever possible.

---

## 15. Common mistakes

### Files are in subfolders

The importer expects the files to be in one flat batch folder.

### Wrong import tool

For the provided example data, use:

```text
Tools → VivoLogic Data Import – v02
```

### Expert Mode accidentally turned on

This can change the workflow and create unexpected prompts.

### Using the wrong file type

Do not confuse:

* raw export files in `vivologicExport/`
  with
* already generated rsaToolbox input files one level above

### Ignoring `errorLog.txt`

Always inspect it before trusting the results.

---

## 16. What to do next

After completing this quickstart, the recommended next reading order is:

1. `docs/worked_example.md`
   for a concrete file-level walkthrough

2. `docs/manual_v2.0.2.md`
   for the full processing workflow and interpretation

3. `docs/manual_preprocessing_spec.md`
   for formal preprocessing requirements

4. `docs/python_reference_preprocessing.md`
   for the Python reference implementation

---

## 17. Summary

For the example dataset, the simplest correct workflow is:

1. copy one `*_Resp.csv` and the matching `*_RR.csv` into one batch folder
2. start `rsaToolbox_v2.0.2.exe`
3. set:

   * Infant Option ON
   * Split Filenames ON
   * Expert Mode OFF
4. run `Tools → VivoLogic Data Import – v02`
5. inspect `data_generated_for_rsaToolbox/` and `errorLog.txt`
6. run `Batch Processing → Compute Simple RSA and RSA/VT`
7. inspect:

   * `OverviewPerInputFile.txt`
   * `OutputPerInputFilePerBreath.txt`

That is the shortest reproducible path from raw example files to valid rsaToolbox output.
