%% script to do things...
clear
clc
close all


%% USER INPUT
% file inputs
dataDir = '..\..\';
TSname = 'TimeSeriesData200.mat';
SSname = 'SteadyData.mat';
jobsToLoad = [1, 2, 3, 12, 13, 14, 15, 25, 26, 27];     % jobs corresponding to locations/configs we care about.

% flow/geometry parameters
Upitot = 25;      % m/s
Utol = 3;         % m/s
minY = -200;   % degs
maxY =  200;   % degs
minZ = -300;

% von Karman Turbulence parameters
vKmaxFreq = 200;        % Hz
Lchar = 1.7;            % characteristic length in m, 1.7m seems to give a PSDF that matches the median turbulence value...

% plotting parameters
runToPlot = 1;          % choose a particular run to focus on when plotting (mainly just provides a comparison to the averages).
component = 'v';        % component to focus on when plotting
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

% create a class instance from the chosen data
TSdat = timeSeriesData(allTSdat(centreLineKeepMask | turbineKeepMask));


%% loop over all runs and compute helpful data
TSdat.computeRMS();
TSdat.oneSidedSpectra();
TSdat.computePeakTurbLength();
TSdat.computeAverages();

lengths = [TSdat.data.turbLength];
rmses = [TSdat.data.rms];
thisRunLength = lengths(compMask, runToPlot);
thisRunRMS = rmses(compMask, runToPlot);

%% calculate a vK PSDF based on the user input
numFreqs = length(TSdat.medians.(component).psdf);
vKfreqs = linspace(0, vKmaxFreq/2, numFreqs);
Umedian = TSdat.medians.U;
vRMSmedian = TSdat.medians.(component).vRMS;
vKpsdf = vKspec(Lchar, Umedian, vRMSmedian, 2*pi*vKfreqs);

disp(['RMS ', component,' velocity for chosen run: ', num2str(thisRunRMS, 3),' m/s'])
disp(['scaled ',component,' turbulence length scale for chosen run: ', num2str(thisRunLength, 3), 'm'])
disp(['mean RMS ', component,' velocity for all runs: ', num2str(TSdat.means.(component).vRMS, 3),' m/s'])
disp(['median RMS ', component,' velocity for all runs: ', num2str(TSdat.medians.(component).vRMS, 3),' m/s'])

% copmpute a representative time series for this von Karman PSDF
[vKtimeSer, vKtimes] = psdfToTime(vKpsdf, vKfreqs);
[medTimeSer, medTimes] = psdfToTime(TSdat.means.(component).psdf, TSdat.medians.(component).fi);
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
TSdat.plotSpecOne(singlePSDF, runToPlot,'psdf', component)
plot(TSdat.means.(component).fi, TSdat.means.(component).psdf,  'displayname', 'Mean PSDF')
plot(TSdat.medians.(component).fi, TSdat.medians.(component).psdf, 'displayname', 'Median PSDF')
xline(TSdat.medians.(component).fPeak, 'DisplayName',['Peak Median ', component])
plot(vKfreqs, vKpsdf, 'DisplayName', 'von Karman PSDF')
title('Power Spectral Density Function')
ylabel('Velocity PSDF [$(\mathrm{m/s})^2/\mathrm{Hz}$]')
ax = gca;
ax.FontSize = 12;
ax.YScale = 'log';
ylim([1e-5 1e-1])
legend


tSeriesFig = figure;
tl = tiledlayout(3,1);
nexttile
plot(TSdat.data(runToPlot).ti, TSdat.data(runToPlot).Vinc(:,compMask), 'DisplayName', ['Run ', num2str(runToPlot),' Velocity Data']);
yline(TSdat.data(runToPlot).rms(compMask), '--', 'DisplayName', 'RMS')
ax = gca;
ax.FontSize = 12;
ylim([-0.75 0.75])
legend()

nexttile
plot(medTimes, medTimeSer, 'displayname', 'Representative Median PSDF Time Series')
ax = gca;
ax.FontSize = 12;
ylim([-0.75 0.75])
legend()

nexttile
plot(vKtimes, vKtimeSer, 'displayname', 'Representative von Karman Time Series')
ax = gca;
ax.FontSize = 12;
ylim([-0.75 0.75])
legend()

xlabel(tl,'Time [s]', 'interpreter', 'latex', 'fontsize', 12)
ylabel(tl,'Velocity [m/s]', 'interpreter', 'latex', 'fontsize', 12)
title(tl,'Representative Time Series Data', 'Interpreter','latex', 'FontSize',12)


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
