classdef timeSeriesData < handle
    %% class to do various handy operations on time series data
    properties
        data
        numJobs
        means
        medians
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

        function computeAverages(obj)
            %% function to compute the mean and median PSDFs over all runs
            
            % get all the data in one place and extract some basic info
            allPsdfs = [obj.data.psdf];
            comps = {'u', 'v', 'w'};
            nComps = length(comps);
            masks = logical(eye(3));
            freqs = obj.data(1).fi;

            % compute the mean freestream velocities so we can compute a turbulence length scale...
            allUs = [obj.data.U];
            obj.means.U = mean(allUs);
            obj.medians.U = median(allUs);

            % loop over the components.
            for i = 1:nComps
                % pick out the PSDFs for this component and compute the averages over all psdfs at each frequency
                mask = repmat(masks(i,:), 1, obj.numJobs);
                componentPsdfs = allPsdfs(:,mask);
                medianPsdf = median(componentPsdfs, 2);     % using dim = 2 specifies to average over all runs at each freq...
                meanPsdf = mean(componentPsdfs, 2);

                % write the results for the mean...
                comp = comps{mask};
                obj.means.(comp).psdf = meanPsdf;
                obj.means.(comp).fi = freqs;
                obj.means.(comp).vRMS = sqrt(trapz(freqs, meanPsdf));   % compute an RMS velocity based on the integral of the average psdf. This will be a different number to the average of all the individually computed RMSes
                [~, peakDex] = max(meanPsdf,[],1);
                obj.means.(comp).fPeak = freqs(peakDex);
                obj.means.(comp).turbLength = obj.means.U/obj.means.(comp).fPeak;

                %...and for the median.
                obj.medians.(comp).psdf = medianPsdf;
                obj.medians.(comp).fi = freqs;
                obj.medians.(comp).vRMS = sqrt(trapz(freqs, medianPsdf));
                [~, peakDex] = max(medianPsdf,[],1);
                obj.medians.(comp).fPeak = freqs(peakDex);
                obj.medians.(comp).turbLength = obj.medians.U/obj.medians.(comp).fPeak;

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
                plot(freqs, spec(:,1),'DisplayName',['u - Run ', num2str(runID)])
                % xline(obj.data(runID).U/obj.data(runID).turbLength(1),'label',['Peak u - Run ', num2str(runID)], 'handlevisibility','off')
            end
            if compMask(2)
                plot(freqs, spec(:,2),'DisplayName',['v - Run ', num2str(runID)])
                % xline(obj.data(runID).U/obj.data(runID).turbLength(2),'label',['Peak v - Run ', num2str(runID)], 'handlevisibility','off')
            end
            if compMask(3)
                plot(freqs, spec(:,3),'DisplayName',['w - Run ', num2str(runID)])
                % xline(obj.data(runID).U/obj.data(runID).turbLength(3),'label',['Peak w - Run ', num2str(runID)], 'handlevisibility','off')
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