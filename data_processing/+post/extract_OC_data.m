function res = extract_OC_data(res,data_path,job)
%EXTRACT_OC_DATA Summary of this function goes here
%   Detailed explanation goes here
oc_file = fullfile(data_path,'WSC_data',sprintf('Job%.0f.csv',job));
data = readmatrix(oc_file,"NumHeaderLines",1);
for j = 1:length(res)
    res(j).U_inf = data(j,13);
    res(j).Delta_U = res(j).U - res(j).U_inf;
    res(j).P_inf = data(j,12)*100;
    res(j).T_inf = data(j,11);
end
end

