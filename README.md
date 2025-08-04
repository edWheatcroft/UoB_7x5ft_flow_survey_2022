### Flow Survey of the 7x5ft Wind Tunnel at the UoB

Ed's Comments/thing's I've figured out:
 - It seems that data_processing/extract_data.m is expecting a different data format to what we have here.
 - Note that the RunOverview.xlsx contains a list of 'jobs', where each job comprises many rows of SteadyData.mat and TimeSeriesData200.mat.
 - The [u,v,w] system in both SteadyData.mat and TimeSeriesData200.mat seem to align with the [x,y,z] system Fintan uses in the WS calibration Appendix (Fig. A1), based the approximate magnitudes of the numbers vs. what's reported in the Appendix.
    - u = Downstream
    - v = Toward the glass
    - w = Up




Fintan's Comments:

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

## Acknowledgements

Thanks to Daniel Pusztai for assisting with the experiments

