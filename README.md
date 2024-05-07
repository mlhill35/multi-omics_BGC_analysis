# Multi-omics BGC Analysis

## Overview

This repository contains a collection of scripts and tools designed to facilitate genome mining and annotation of biosynthetic gene clusters (BGCs) involved in the production of known specialized/secondary metabolites. The pipeline provided herein allows researchers to verify the presence of these BGCs in sample genomes, but also to analyze and correlate them with mass spectrometry data to predict their presence in samples (environmental or otherwise).

Key components of this repository include:

- **Gene Cluster Identification**: Utilizes RAST annotation for genome mining and a shell script leveraging tBLASTn to identify BGCs using protein sequence files downloaded from UniProt. 

- **Data Visualization and Analysis**: R scripts are provided to generate figures that visualize the genes identified, complementing the genomic data analysis. These scripts help in interpreting the complex data and facilitate easier understanding of gene distribution and relationships.

- **Mass Spectrometry Data Analysis**: A Python script analyzes mass spec data, including precursor ions and MS2 fragment ions, to identify potential metabolites associated with the biosynthetic gene clusters identified earlier in the pipeline. This script is crucial for linking genomic data with actual biochemical output.

- **Metabolite Correlation Representation**: Further R scripts are included to represent the presence of ions correlated with the identified gene clusters. This allows for a more targeted approach in understanding the metabolic pathways and their outputs.

This pipeline is aimed at interdisciplinary researchers who require a multi-omics approach to integrate genomic data with metabolic profiling for the characterization of known secondary metabolites. By using this toolkit, researchers can streamline their analysis process, from gene cluster identification to metabolite prediction.
