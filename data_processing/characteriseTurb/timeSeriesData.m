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
                obj.data(runID).Vinc = obj.data(runID).Vi - mean(obj.data(runID).Vi);
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
                binSize = Fs/L;
                freqsOneSided = Fs/L*(0:(L/2));
                % freqsTwoSided = Fs/L*(0:L-1);
                

                % take transform
                transform = fft(obj.data(runID).Vinc);
                fullSpec = abs(transform);
                specOne = fullSpec(1:ceil(L/2),:);         % This should be correct for odd and even length signals I think...
                specOne(2:end-1,:) = 2*specOne(2:end-1,:);

                obj.data(runID).fi = freqsOneSided;
                obj.data(runID).specOneSided = specOne/L;           % division by L preserves units...
                obj.data(runID).psdf = (specOne/L).^2/(2*binSize);  % The 2 in the denominator is because each bin actually accounts for twice as much frequency due to the smooshing from 2-sided to 1-sided.
                                                                    % Frankly, fourier normalisation is all a bit fudgy imo - this gives the
                                                                    % correct RMS velocity if you integrate it over the one sided
                                                                    % frequencies.                
                
                % sanity check: all these should give the same (correct) answer - Fourier stuff is all a matter of your scaling...
                % rms = sqrt(trapz(freqsOneSided, psdf))
                % rms = sqrt(trapz(specOne.^2/2)/(L^2));
                % rms = sqrt(trapz(freqsTwoSided, (fullSpec/L).^2/binSize))
            end
        end

        function computePeakTurbLength(obj)
            %% compute the peak turbulence frequency, and thus length scale, for all series
            for runID = 1:obj.numJobs
                [~, peakDex] = max(obj.data(runID).specOneSided, [], 1);
                obj.data(runID).turbLength = (obj.data(runID).U./obj.data(runID).fi(peakDex))';
            end
        end


        function plotSpecOne(obj, fig, runID, type, component)
            %% plot the one sided spectrum for a given run. Type is a field of obj.data pertaining to either the field or power spectrum
            figure(fig)
            hold on
            compMask = strcmp(component,{'u', 'v', 'w'});
            spec = obj.data(runID).(type);
            freqs = obj.data(runID).fi;
            if compMask(1)
                plot(freqs, spec(:,1),'DisplayName','u')
                xline(obj.data(runID).U/obj.data(runID).turbLength(1),'label','u', 'handlevisibility','off')
            end
            if compMask(2)
                plot(freqs, spec(:,2),'DisplayName','v')
                xline(obj.data(runID).U/obj.data(runID).turbLength(2),'label','v', 'handlevisibility','off')
            end
            if compMask(3)
                plot(freqs, spec(:,3),'DisplayName','w')
                xline(obj.data(runID).U/obj.data(runID).turbLength(3),'label','w', 'handlevisibility','off')
            end

            xlim([0 50])
            xlabel('Freq [Hz]')
            grid on

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