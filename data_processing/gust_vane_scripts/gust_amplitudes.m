clear all
job = 38:40;
load("..\TimeSeriesData200.mat")
res = farg.struct.filter(final_data,{{'Job',job}});
res = res(2:end);

%% update cobra info
for i = 1:length(res)
    res(i).U = mean(vecnorm(res(i).Vmean'));
    res(i).u = mean(res(i).Vi(:,1));
    res(i).v = mean(res(i).Vi(:,2));
    res(i).w = mean(res(i).Vi(:,3));
    res(i).u_min = min(res(i).Vi(:,1));
    res(i).v_min = min(res(i).Vi(:,2));
    res(i).w_min = min(res(i).Vi(:,3));
    res(i).u_max = max(res(i).Vi(:,1));
    res(i).v_max = max(res(i).Vi(:,2));
    res(i).w_max = max(res(i).Vi(:,3));
end

for i = 1:length(res)
    if isempty(res(i).Frequency)
        res(i).Frequency = nan;
    end
    if isempty(res(i).Amplitude)
        res(i).Amplitude = nan;
    end
end
%% save the results
Vs = [15,20,25,30]; % [15,20,25,30]
Amps = [4,8,12,15];
Fs = [1,2,3.5,5,7.5,10,12.5,15];
xs = [-400,0,400];
gust_data = struct();
idx = 1;
for v_i = 1:length(Vs)
    for f_i = 1:length(Fs)
        for a_i = 1:length(Amps)
            for x_i = 1:length(xs)
            ffilt = {{'U_inf',{'tol',Vs(v_i),1}},{'Amplitude',Amps(a_i)},{'Frequency',Fs(f_i)},{'x',xs(x_i)}};
            tmpMeta = farg.struct.filter(res,ffilt);
            gust_data(idx).V = Vs(v_i);
            gust_data(idx).U = mean([tmpMeta.U]);
            gust_data(idx).F = Fs(f_i);
            gust_data(idx).Amp = Amps(a_i);
            gust_data(idx).x = xs(x_i);
            gust_data(idx).w = mean([tmpMeta.w_max]);
            gust_data(idx).w_std = std([tmpMeta.w_max]);
            gust_data(idx).w_min = mean([tmpMeta.w_max]) - min([tmpMeta.w_max]);
            gust_data(idx).w_max = max([tmpMeta.w_max]) - mean([tmpMeta.w_max]);
            idx = idx + 1;
            end
        end
    end
end
save('gust_vane_scripts/GustAmpData.mat','gust_data')



