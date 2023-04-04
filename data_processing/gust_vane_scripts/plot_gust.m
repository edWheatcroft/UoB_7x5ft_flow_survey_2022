jobs = [40];
load("..\TimeSeriesData200.mat")
final_data = farg.struct.filter(final_data,{{'Job',jobs}});
c = fh.colors.colorspecer(3,'qual','HighCon');
final_data = final_data(2:end);
%% get time series
amp = [15];
% Freqs = unique([final_data.Frequency]);
Freqs = 10;
U_p = 15; %[15,20,25,30]
U = 1.052*U_p + 0.258;
tmp_res = farg.struct.filter(final_data,{{'Frequency',Freqs},{'Amplitude',amp},{'U',{'tol',U,1}}});

F_new = 1;
for i = 1:length(tmp_res)   
    % shift time to get new freqeuncy
    Vi = tmp_res(i).Vi;
%     ti = ti./(1/tmp_res(i).Frequency).*(1/F_new);
    % shift the peak to be at 1 second
    [~,idx] = max(Vi(:,3));
    ti = ti - ti(idx) + 1;
    idx = ti>=0;
    ti = ti(idx);
    Vi = Vi(idx,:);
    % filter last 0.5 seconds to a constant value
    t_max = max(ti);
    Vmean = repmat(mean(Vi),numel(ti),1);
    Vi = Vi - Vmean;
    weights = ones(size(ti));
    t_smooth = 0.25;
    idx = ti>=(t_max-t_smooth);
    weights(idx) = 1-((ti(idx)-(t_max-t_smooth))/t_smooth);
    idx = ti<=(t_smooth);
    weights(idx) = ti(idx)/t_smooth;
    Vi = Vmean + Vi.*repmat(weights',1,3);
    tmp_res(i).ti = ti;
    tmp_res(i).Vi = Vi;
end

figure(1);clf;
% for i = 2:3
%     tmp_res(1).Vi(1:1200,:) = tmp_res(1).Vi(1:1200,:) + tmp_res(i).Vi(1:1200,:);
% end
% tmp_res(1).Vi = tmp_res(1).Vi./3;
tmp_res = tmp_res(1);
tt = tiledlayout(3,1);
nexttile(1);
hold on
for i = 1:length(tmp_res)
plot(tmp_res(i).ti,tmp_res(i).Vi(:,1))
end
xlim([0 3])
xlabel('time [s]')
ylabel('u [m/s]')
nexttile(2);
hold on
for i = 1:length(tmp_res)
plot(tmp_res(i).ti,tmp_res(i).Vi(:,3))
end
xlim([0 3])
xlabel('time [s]')
ylabel('w [m/s]')
nexttile(3);
hold on
for i = 1:length(tmp_res)
plot(tmp_res(i).ti,vecnorm(tmp_res(i).Vi')')
end
xlabel('time [s]')
xlim([0 3])
ylabel('V [m/s]')
% save to file
V = tmp_res.Vi;
t = tmp_res.ti;
% save('gust_vane_scripts/gust_9d5_amp_15.mat',"V","t");


figure(2);clf;
idx = t>0 & t<.5;
[f,P1,df] = farg.signal.psd(V(idx,3),400);
plot(f,P1)
xlim([0,20])


