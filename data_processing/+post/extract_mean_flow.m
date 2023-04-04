function res = extract_mean_flow(res,data_path)
%EXTRACT_MEAN_FLOW Summary of this function goes here
%   Detailed explanation goes here
for i = 1:length(res)
    [~,name,~] = fileparts(res(i).TFI_filename);
    tfi_path = fullfile(data_path,'TFI-Data',sprintf('Job_%.0f',res(i).Job),[name,' (Ve).thA']);
    if ~isfile(tfi_path)
        error('File does nto exist')
    end
    [u,v,w,~,~] = tfi.ReadTHFile(tfi_path);
    % convert velocity vector to tunnel coord
    V = [u,v,w];
    V = V*fh.rotx(res(i).Roll);
    V_mean = mean(V);
    V_prime = rms(V-V_mean);
    v_prime = sqrt(1/3*(sum(V_prime.^2)));
    [U,pitch,yaw] = tfi.VelPitchYaw(V(:,1),V(:,2),V(:,3));
    res(i).U = mean(U);
    res(i).u = V_mean(1);
    res(i).v = V_mean(2);
    res(i).w = V_mean(3);
    res(i).pitch = mean(pitch);
    res(i).yaw = mean(yaw);
    res(i).flow_angle = atan2d(V_mean(1),norm(V_mean(2:3)));
    res(i).turb_u = V_prime(1)/res(i).U*100;
    res(i).turb_v = V_prime(2)/res(i).U*100;
    res(i).turb_w = V_prime(3)/res(i).U*100;
    res(i).turb = v_prime/res(i).U*100;
end
end

