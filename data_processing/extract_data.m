jobs = 1:45;

%% create data
final_data = [];
for j_i = 1:length(jobs)
    % get matlab data
    data_path = 'C:\Users\qe19391\OneDrive - University of Bristol\Bristol_Documents\Wind Tunnel Data\Flow_Characterisation';
    load(fullfile(data_path,'Matlab_data',sprintf('Job%.0f.mat',jobs(j_i))),'res'); 

    res = post.extract_mean_flow(res,data_path);
    res = post.extract_probe_location(res);
    res = post.extract_OC_data(res,data_path,jobs(j_i));
    res = post.extract_time_series(res,data_path,'fpass',50,'OutputRate',200);
    
    final_data = farg.struct.concat(final_data,res);
end