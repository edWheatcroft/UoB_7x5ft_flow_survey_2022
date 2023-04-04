function res = extract_time_series(res,data_path,opts)
arguments
    res
    data_path
    opts.fpass = 30;
    opts.OutputRate = 100;
end
%EXTRACT_MEAN_FLOW Summary of this function goes here
%   Detailed explanation goes here
for i = 1:length(res)
    [~,name,~] = fileparts(res(i).TFI_filename);
    tfi_path = fullfile(data_path,'TFI-Data',sprintf('Job_%.0f',res(i).Job),[name,' (Ve).thA']);
    if ~isfile(tfi_path)
        error('File does nto exist')
    end
    [u,v,w,~,s] = tfi.ReadTHFile(tfi_path);
    t = (0:length(u)-1)*1/s.DataRate;
    % convert velocity vector to tunnel coord
    V = [u,v,w];
    V = (V*fh.rotx(res(i).Roll));
    % low pass filter
%     V = lowpass(V,opts.fpass,s.DataRate);
    % down sample to 100 Hz
    tnew = 0:(1/opts.OutputRate):max(t);
    Vnew = interp1(t',V,tnew','linear'); %zeros(numel(tnew),3);
    Vmean = repmat(mean(Vnew),size(Vnew,1),1);
    Vnew = lowpass(Vnew-Vmean,opts.fpass,opts.OutputRate)+Vmean;
%     for j = 1:3
%         Vnew(:,j) = interp1(t,V(:,j),tnew,'linear');
%     end
    res(i).Vmean = Vmean;
    res(i).Vi = Vnew;
    res(i).ti = tnew;
end
end

