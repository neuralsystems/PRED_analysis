## Description

The repository contains all the source code and data files to reproduce the results in our manuscript comparing features of PRED with other metrics of vector similarity and class separability

## Getting Started

Download the source files, extract to a new folder, and add this folder and all its sub-folders to your MATLAB path

## Prerequisites

- MATLAB (this code has been tested in version r2020a)
- Statistics and Machine Learning Toolbox
- Curve Fitting Toolbox

## Running the code

Please run the `main` function to reproduce all results and figures. It will run all simulations, run analyses on these simulations and create the figure files

## Dataset details

The folder named `data` contains all the dataset files used in the code. The `runallsimulations` function generates the `.mat` files used for plotting the datasets. The details of each dataset is as follows:

- Fly GCaMP3 data: The stereotypy values for each lobe for each odor are specified in the file fly_mbon_gcamp3_stereotypy.xlsx. 'wt' and 'APL>TNT' data is marked accordingly. The raw data images are available on request from the authors.
- Locust bLN1 data: The file bln1_stereotypy.mat contains the spike rates extracted from the raster plots in Supplementary Fig. 1a in the variable meanfiringNorm in the format num_individual x num_odors. Raw traces are available on request from the authors.
- Shimizu and Stopfer 2017 data: The file shimizu_2017.xlsx describes the data files (present in the raw folder) containing spike time data for each PN and odor. Raw traces are available on request from the authors.

## Built With

- MATLAB (version r2020a)
- modified version of the `gramm` plotting package available at [piermorel/gramm](https://github.com/piermorel/gramm). We modified the `stat_violin` function to suit our plotting needs
- `export_fig` toolbox available at [altmany/export_fig](https://github.com/altmany/export_fig)

## Authors

- Aarush Mohit Mittal - All files except `gramm` and `export_fig` packages

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE.md) file for details
