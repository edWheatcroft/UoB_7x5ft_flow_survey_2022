function data = loadData(pathToFile, jobsToLoad)
%% function to load in specific jobs


arguments
    pathToFile string
    jobsToLoad = NaN;
end

% get the data
d = load(pathToFile);
fNames = fields(d);
d = d.(fNames{1});

% filter out only the jobs we want
if ~isnan(jobsToLoad)
    [jobMask,~] = ismember([d.Job], jobsToLoad);
    data = d(jobMask);
else
    data = d;
end



