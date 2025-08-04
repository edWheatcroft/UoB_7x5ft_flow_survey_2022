%% script to do things...
clear
clc
close all


%% USER INPUT
% file inputs
dataDir = '..\..\';
TSname = 'TimeSeriesData200.mat';
SSname = 'SteadyData.mat';
jobsToLoad = [1, 2, 3, 12, 13, 14, 15, 25, 26, 27];

% flow/geometry parameters
Upitot = 25;      % m/s
Utol = 3;         % m/s
minY = -200;   % degs
maxY =  200;   % degs
minZ = -300;
%%%%%%%%%% END %%%%%%%%%%

% useful stuff
TSpath = fullfile(dataDir, TSname);
SSpath = fullfile(dataDir, SSname);
Unom = 1.0288*Upitot + 0.268;

%% load in data and get the runs we want
allTSdat = loadData(TSpath, jobsToLoad);

% make some masks of things we want to keep...
% on the centreline we only care about runs where radius == 0 and velocity between our limits 
cond1 = [allTSdat.U] >= Unom - Utol  &  [allTSdat.U] <= Unom + Utol;
cond2 = [allTSdat.Radius] == 0;
centreLineKeepMask = cond1' & cond2';

% for turbine runs we must satisfy the velocity condition, and have y/z between our limits
cond3 = [allTSdat.y] >= minY  &  [allTSdat.y] <= maxY  &  [allTSdat.z] >= minZ;      
turbineKeepMask = cond1' & cond3';

TSdat = timeSeriesData(allTSdat(centreLineKeepMask | turbineKeepMask));


%% loop over all runs and compute helpful data
TSdat.computeRMS();
TSdat.oneSidedSpectra();
TSdat.computePeakTurbLength();

lengths = [TSdat.data.turbLength];
rmses = [TSdat.data.rms];

%% plot stuff
singleSpec = figure;
TSdat.plotSpecOne(singleSpec,22)
legend

lengthSurf = figure;
TSdat.plot3D(lengthSurf, lengths(2,:))          % take 20m conservatively?
zlabel('$L_\mathrm{turb}$ [m]')

rmsSurf = figure;
TSdat.plot3D(rmsSurf, rmses(2,:))               % take 0.25-0.3 conservatively?
zlabel('$v_\mathrm{RMS}$ [m/s]')

