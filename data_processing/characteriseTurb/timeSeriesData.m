classdef timeSeriesData < handle
    %% class to do various handy operations on time series data
    properties
        data
        numJobs
    end


    methods 
        function obj = timeSeriesData(inputData)
            %% constructor
            obj.data = inputData;
            obj.numJobs = length(inputData);
        end

        function computeRMS(obj)
            %% compute the RMS values of time series data EXCLUDING DC component...
            for runID = 1:obj.numJobs
                obj.data(runID).Vinc = obj.data(runID).Vi - obj.data(runID).Vmean;
                obj.data(runID).rms = rms(obj.data(runID).Vinc, 1)';
            end
        end

        function oneSidedSpectra(obj)
            %% compute the one sided spectra of all time series.
            % also create a column of the one sided frequencies
            for runID = 1:obj.numJobs
                % compute freq vector
                Ts = obj.data(runID).ti(2) - obj.data(runID).ti(1);
                Fs = 1/Ts;
                L = length(obj.data(runID).ti);
                freqsOneSided = Fs/L*(0:(L/2));

                % take transform
                fullSpec = abs(fft(obj.data(runID).Vinc));
                specOne = fullSpec(1:ceil(L/2),:);         % not 100% sure we're not chopping off the last bin sometimes here. Doesn't really matter as it'll be tiny...
                specOne(2:end-1,:) = 2*specOne(2:end-1,:);

                % rms = sqrt(trapz(specOne.^2/2)/(L^2));        % should give correct answer...

                obj.data(runID).specOneSided = specOne/L;       % division by L preserves units...
                obj.data(runID).fi = freqsOneSided;
            end
        end

        function computePeakTurbLength(obj)
            %% compute the peak turbulence frequency, and thus length scale, for all series
            for runID = 1:obj.numJobs
                [~, peakDex] = max(obj.data(runID).specOneSided, [], 1);
                obj.data(runID).turbLength = (obj.data(runID).U./obj.data(runID).fi(peakDex))';
            end
        end


        function plotSpecOne(obj, fig, runID)
            %% plot the one sided spectrum for a given run
            figure(fig)
            spec = obj.data(runID).specOneSided;
            freqs = obj.data(runID).fi;
            plot(freqs, spec(:,1),'DisplayName','u')
            hold on
            plot(freqs, spec(:,2),'DisplayName','v')
            plot(freqs, spec(:,3),'DisplayName','w')
            xlim([0 50])
            xlabel('Freq [Hz]')
            grid on

            xline(obj.data(runID).U/obj.data(runID).turbLength(1),'label','u', 'handlevisibility','off')
            xline(obj.data(runID).U/obj.data(runID).turbLength(2),'label','v', 'handlevisibility','off')
            xline(obj.data(runID).U/obj.data(runID).turbLength(3),'label','w', 'handlevisibility','off')

        end


        function plot3D(obj, fig, var)
            %% plot var against y and z
            figure(fig)

            xDat = [obj.data.y];
            yDat = [obj.data.z];

            scatter3(xDat, yDat, var)

            xlabel('y [mm]')
            ylabel('z [mm]')
            



        end



    end


end