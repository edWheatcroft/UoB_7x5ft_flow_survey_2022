clear all
job = 42;
load("..\TimeSeriesData200.mat")
res = farg.struct.filter(final_data,{{'Job',job}});
res = res(2:end);

%% update cobra info
for i = 1:length(res)
    res(i).U = mean(vecnorm(res(i).Vmean'));
    res(i).u = mean(res(i).Vi(:,1));
    res(i).v = mean(res(i).Vi(:,2));
    res(i).w = mean(res(i).Vi(:,3));
    res(i).U_std = std(vecnorm(res(i).Vi')-res(i).U);
    res(i).u_std = std(res(i).Vi(:,1)'-res(i).u);
    res(i).v_std = std(res(i).Vi(:,2)'-res(i).v);
    res(i).w_std = std(res(i).Vi(:,3)'-res(i).w);
    res(i).U_rms = rms(vecnorm(res(i).Vi')-res(i).U)./res(i).U*100;
    res(i).u_rms = rms(res(i).Vi(:,1)'-res(i).u)./res(i).U*100;
    res(i).v_rms = rms(res(i).Vi(:,2)'-res(i).v)./res(i).U*100;
    res(i).w_rms = rms(res(i).Vi(:,3)'-res(i).w)./res(i).U*100;
    [f,P] = farg.signal.psd(detrend(vecnorm(res(i).Vi'),1),400);
    res(i).P1U = P;
    [f,P] = farg.signal.psd(detrend(res(i).Vi(:,3)'./res(i).U,1),400);
    res(i).f = f;
    res(i).P1w = P;
    [f,P] = farg.signal.psd(detrend(res(i).Vi(:,1)'./res(i).U,1),400);
    res(i).P1u = P;
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
Amps = [2.5,5];
delays = [0,1,2];
turb_data = struct();
idx = 1;
for v_i = 1:length(Vs)
    for a_i = 1:length(Amps)
        for d_i = 1:length(delays)
        ffilt = {{'U_inf',{'tol',Vs(v_i),1}},{'Amplitude',Amps(a_i)},{'Delay',delays(d_i)}};
        tmpMeta = farg.struct.filter(res,ffilt);
        turb_data(idx).V = Vs(v_i);
        turb_data(idx).Amp = Amps(a_i);
        turb_data(idx).Delay = delays(d_i);
        turb_data(idx).U_rms = mean([tmpMeta.U_rms]);
        turb_data(idx).u_rms = mean([tmpMeta.u_rms]);
        turb_data(idx).v_rms = mean([tmpMeta.v_rms]);
        turb_data(idx).w_rms = mean([tmpMeta.w_rms]);
        turb_data(idx).f = tmpMeta(1).f;
        turb_data(idx).P1U = tmpMeta(1).P1U;
        turb_data(idx).P1w = tmpMeta(1).P1w;
        turb_data(idx).P1u = tmpMeta(1).P1u;
        idx = idx + 1;
        end
    end
end
save('gust_vane_scripts/TurbAmpData.mat','turb_data')



