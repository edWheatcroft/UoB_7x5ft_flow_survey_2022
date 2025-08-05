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

% von Karman Turbulence parameters
vKmaxFreq = 200;        % Hz
lengthScalingFactor = 0.05;

% plotting parameters
runToPlot = 20;
component = 'v';
%%%%%%%%%% END %%%%%%%%%%

% useful stuff
TSpath = fullfile(dataDir, TSname);
SSpath = fullfile(dataDir, SSname);
Unom = 1.0288*Upitot + 0.268;
compMask = strcmp(component,{'u', 'v', 'w'});

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

%% calculate the pertinent vK PSDF
sigLength = length(TSdat.data(runToPlot).ti);
vKfreqs = linspace(0, vKmaxFreq/2, ceil(sigLength/2));
Lchar = TSdat.data(runToPlot).turbLength(compMask)*lengthScalingFactor;
U = TSdat.data(runToPlot).U;
vRMS = TSdat.data(runToPlot).rms(compMask);
vKpsdf = vKspec(Lchar, U, vRMS, 2*pi*vKfreqs); 

% copmpute a representative time series for this von Karman PSDF
[vKtimeSer, vKtimes] = psdfToTime(vKpsdf, vKfreqs);
% for comparison/checking, reconstruct the time series of the actual data from its PSDF
[vRec, tRec]  = psdfToTime(TSdat.data(runToPlot).psdf(:,compMask), TSdat.data(runToPlot).fi);

%% plot stuff
singleFieldSpec = figure;
TSdat.plotSpecOne(singleFieldSpec,runToPlot,'specOneSided', component)
title('Field Spectrum')
ylabel('Velocity [m/s]')
ax = gca;
ax.FontSize = 12;
legend

singlePSDF = figure;
TSdat.plotSpecOne(singlePSDF,runToPlot,'psdf', component)
plot(vKfreqs, vKpsdf, 'DisplayName', 'von Karman PSDF')
title('Power Spectral Density Function')
ylabel('Velocity PSDF [$(\mathrm{m/s})^2/\mathrm{Hz}$]')
ax = gca;
ax.FontSize = 12;
legend

tSeriesFig = figure;
hold on
a = plot(TSdat.data(runToPlot).ti, TSdat.data(runToPlot).Vinc(:,compMask), 'DisplayName', 'Original Velocity Data');
% plot(tRec, vRec, 'DisplayName', 'Reconstructed Velocity Data')
yline(TSdat.data(runToPlot).rms(compMask), '--', 'DisplayName', 'RMS')
plot(vKtimes, vKtimeSer, 'displayname', 'Representative von Karman Time Series')
xlabel('Time [s]')
ylabel('Velocity [m/s]')
ax = gca;
ax.FontSize = 12;
legend()


lengthSurf = figure;
TSdat.plot3D(lengthSurf, lengths(2,:))          % take 20m conservatively?
zlabel('$L_\mathrm{turb}$ [m]')
ax = gca;
ax.FontSize = 12;

rmsSurf = figure;
TSdat.plot3D(rmsSurf, rmses(2,:))               % take 0.25-0.3 conservatively?
zlabel('$v_\mathrm{RMS}$ [m/s]')
ax = gca;
ax.FontSize = 12;



function psdf = vKspec(lengthScale, flightSpeed, wg_rms, angularFreqs)
    %% quick function to make a von Karman turbulence spectrum (as per NASTRAN TABRNDG).
    % This should produce a function whose integral w.r.t. f (=angularFreqs/(2*pi)) over the interval [0 Inf] is wg_rms^2.

    p = 1/3;
    k = 1.339;
    Tchar = lengthScale/flightSpeed;

    numer = 1 + 2*(p+1)*k^2*Tchar^2*angularFreqs.^2;
    denom = (1 + k^2*Tchar^2*angularFreqs.^2).^(p + 3/2);

    psdf = 2*wg_rms^2*Tchar*numer./denom;
end


function [timeSeries, timeVector] = psdfToTime(psdf, freqs)
    %% a function to compute a time series from a psdf.
    % This works by un-doing the psdf scaling then assuming random phase.
    arguments
        psdf (1,:) double
        freqs (1,:) double
    end

    % compute handy things
    binSize = freqs(2) - freqs(1);
    L1 = length(freqs);
    L2 = 2*L1-1;            % two sided spectrum is twice the length of the one sided, minus the DC component
    Fs = binSize*L2;
    Ts = 1/Fs;

    % undo the psdf scaling
    specReal = (psdf*2*binSize).^0.5*L2;        % we normalised by the two sided length 

    % generate one-sided random phase data
    specPhase = (2*pi) * rand(1, L1) - pi;
    specPhase(1) = 0;                       % DC component should have zero phase by convention.

    % re-construct 2 sided spectrum
    i = sqrt(-1);
    specOneSided = specReal.*exp(i*specPhase);
    specTwoSided = [specOneSided(1) specOneSided(2:end)/2 fliplr(conj(specOneSided(2:end)/2))];

    timeSeries = ifft(specTwoSided);
    timeVector = (0:length(timeSeries)-1)*Ts;



end
