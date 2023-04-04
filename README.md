### Flow Survey of the 7x5ft Wind Tunnel at the UoB

The repository contains data from a flow survery conducted in the 7x5ft wind tunnel at the Univeristy of Bristol in 2022. It is complimentary to the Appendix within my Thesis (WIP).

RunOverview.xlsx contains a breakdown of each `job' completed, where a job specifies a tunnel configuration:
    - x is the x location of the cobra probe
    - Roof specifies which roof panel were install in the front middle and rear of the working section
    - Radius specific the radius between the cobra probe and the centreline using the rotary flow survey rig
    - Description provides an overview of what `runs' where completed during the Job

The full cobra probe data was sampled at 5kHz and is too large to upload to github - so instead mean values (SteadyData.mat) and downsampled time series (TimeSeriesData400.mat) is provided here - if you would like the full data please contact me at fintan.healy@bristol.ac.uk

NOTE - TimeSeriesData200.mat is downsampled at 200Hz and a low-pass filter was applied with a cutoff frequency of 50Hz

The files contained in `data_processing' represent the files require to regenerate the plots in the report.

functions of note:
    - data_processing/gust_vane/scripts/wg_interp.m estimate the vertical gust velocity for a 1MC gust at a given tunnel velocity, gust frequency and gust vane amplitude

## Acknowldements

Thanks to Daniel Pusztai for assisting with the experiments

