# Multi-omics BGC Analysis

## Overview

This repository hosts a suite of R and shell scripts designed for the comprehensive analysis of biosynthetic gene clusters (BGCs). These scripts facilitate genome mining, annotation of BGCs, and the integration of genomic data with metabolomics, enhancing the study of secondary metabolites produced by various organisms.

### Features

- **Gene Cluster Identification**: Utilizes RAST annotation and tBLASTn to identify genetic elements and presence of BGCs.
- **Data Visualization and Analysis**: Provides R scripts for visualizing gene distributions and relationships, aiding in the interpretation of complex genomic data.
- **Mass Spectrometry Data Analysis**: R scripts analyze mass spectrometry data to identify potential metabolites related to BGCs, linking genomic data with biochemical outputs.

## Installation

### Prerequisites
- R (version 4.2.3)
- RStudio (recommended for running R scripts)
- Shell environment (e.g., Bash on Linux/Unix or Git Bash on Windows)
- BLAST+ (version 2.13)

### Cloning the Repository
To use these tools, start by cloning this repository:
```bash
git clone https://github.com/mlhill35/multi-omics_BGC_analysis.git
cd multi-omics_BGC_analysis
```

## Setup
Ensure R is installed on your system by checking the version, which should be at least 4.2.3:
```bash
R --version
```
To install necessary R packages:
```bash
install.packages(c("dplyr", "ggplot2", "tidyr", "gridExtra"))
```

## Usage

### Gene Cluster Identification
Run the shell script tblastn_bgc.sh to identify gene clusters:
```bash
./tblastn_bgc.sh path/to/genome.fasta path/to/protein_sequences_folder e_value_cutoff
```
### Data Analysis and Visualization
Provided that your data files are named the same as those provided under the example_data older, execute the R scripts to analyze and visualize genomic and mass spectrometry data:
```bash
Rscript RAST_data_analysis.R
Rscript blast_data_analysis.R
Rscript mass_spec_mining.R
Rscript mass_spec_data_analysis.R
```

## Contributing
Contributions to enhance or extend the functionality of these scripts are welcome. Please fork the repository, make your changes, and submit a pull request.

## License
This project is licensed under the MIT License.
