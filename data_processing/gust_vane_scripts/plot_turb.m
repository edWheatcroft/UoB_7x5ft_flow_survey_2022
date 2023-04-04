jobs = [42];
load("..\TimeSeriesData200.mat")
final_data = farg.struct.filter(final_data,{{'Job',jobs}});
c = fh.colors.colorspecer(3,'qual','HighCon');
final_data = final_data(2:end);
%% get time series
amp = [5];
% Freqs = unique([final_data.Frequency]);
Freqs = 10;
U = 27; %[16,21,27,32]
tmp_res = farg.struct.filter(final_data,{{'Amplitude',amp},{'Delay',0},{'U',{'tol',U,1}}});

% adjust time series to suit
amp = 4;
for i = 1:length(tmp_res)   
    ti = tmp_res(i).ti;
    Vi = tmp_res(i).Vi;
    % cut after 25 seconds
    idx = ti<=25;
    ti = ti(idx);
    Vi = Vi(idx,:);
    % filter first and last 0.5 seconds to a constant value
    t_max = max(ti);
    Vmean = repmat(mean(Vi),numel(ti),1);
    Vi = Vi - Vmean;
    weights = ones(size(ti));
    t_smooth = 1;
    idx = ti>=(t_max-t_smooth);
    weights(idx) = 1-((ti(idx)-(t_max-t_smooth))/t_smooth);
    idx = ti<=(t_smooth);
    weights(idx) = ti(idx)/t_smooth;
    % scale for new amplitude
    weights = weights./tmp_res(i).Amplitude*amp;
    Vi = Vmean + Vi.*repmat(weights',1,3);
    tmp_res(i).ti = ti;
    tmp_res(i).Vi = Vi;
end

figure(1);clf;
tmp_res = tmp_res(1);
tt = tiledlayout(3,1);
nexttile(1);
hold on
for i = 1:length(tmp_res)
plot(tmp_res(i).ti,tmp_res(i).Vi(:,1))
end
xlabel('time [s]')
ylabel('u [m/s]')
nexttile(2);
hold on
for i = 1:length(tmp_res)
plot(tmp_res(i).ti,tmp_res(i).Vi(:,3))
end
xlabel('time [s]')
ylabel('w [m/s]')
nexttile(3);
hold on
for i = 1:length(tmp_res)
plot(tmp_res(i).ti,vecnorm(tmp_res(i).Vi')')
end
xlabel('time [s]')
ylabel('V [m/s]')
% save to file
V = tmp_res.Vi;
t = tmp_res.ti;
save('gust_vane_scripts/turb_amp_4.mat',"V","t");


