# Maximum Entropy (MaxEnt) Presence Prediction Model

This repository contains a species distribution modeling workflow for predicting the potential distribution of Ageratum conyzoides using maximum entropy (MaxEnt) and environmental predictor variables.

The project focuses on preparing and visualizing environmental layers such as climate variables, elevation, slope, and NDVI, then generating summary figures for ecological interpretation and reporting.

## Project Overview

The analysis combines:

- geospatial environmental variables in ASCII grid format (.asc)
- maximum entropy (MaxEnt) modeling principles
- R-based preprocessing and mapping
- publication-style figure outputs for main and appendix results

This repository is designed for a research or coursework setting where species occurrence and environmental suitability are assessed spatially.

## Repository Contents

- `Maps_Showing_clipped_layers.R`  
  R script used to load environmental raster layers, check alignment, summarize variables, and produce map panels.

- `figures/Fig4_clipped_layers_main.png`  
  Main figure showing key environmental variables.

- `figures/FigA_clipped_layers_appendix.png`  
  Appendix figure showing additional environmental layers.

- `Maxent_Output_Ageratum_Conyzoids.zip`  
  Archived output from the MaxEnt modeling workflow.

- `Yeshashwini_M2024BSASS033_Ageratum conyzoides .pdf`  
  Project report or assignment document associated with the modeling work.

## Methodology

The workflow in `Maps_Showing_clipped_layers.R` includes:

- loading raster layers from a local folder
- verifying that all predictor layers share the same extent and resolution
- assigning a coordinate reference system (`EPSG:4326`)
- generating summary tables of each variable
- plotting environmental layers with consistent styling
- exporting maps for presentation and reporting

The script uses the `terra` R package and is structured to visualize environmental variables related to climate and topography.

## Requirements

To run the scripts in this repository, you need:

- R (version 4.x or later recommended)
- `terra` package
- access to the environmental ASCII layer files (`.asc`)

Install the required package in R:

```r
install.packages("terra")
