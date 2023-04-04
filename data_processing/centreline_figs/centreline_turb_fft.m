jobs = [1:3];
load("..\TimeSeriesData400.mat")
final_data = farg.struct.filter(final_data,{{'Job',jobs}});
c = fh.colors.colorspecer(3,'qual','HighCon');

f = figure(1);
f.Units = "centimeters";
f.Position = [4,4,16,8];
clf;
tt = tiledlayout(1,4);
tt.Padding = "compact";
tt.TileSpacing = 'compact';

Vs = [15,20,25,30];

for i = 1:length(Vs)
    ax = nexttile(i);
    tmp_res = farg.struct.filter(final_data,{{'U_inf',{'tol',Vs(i),1}}});
    n = 2^nextpow2(length(tmp_res(1).ti))/2;
    Ps = zeros(n,length(tmp_res));
    for j = 1:length(tmp_res)
        Y = (tmp_res(j).Vi - tmp_res(j).Vmean)'./vecnorm(tmp_res(j).Vmean');
        Y = vecnorm(Y)';
%         Y = vecnorm(tmp_res(j).Vi')./vecnorm(tmp_res(j).Vmean');
%         Y = tmp_res(j).Vi(:,3)'./vecnorm(tmp_res(j).Vmean');
        Y = detrend(Y,1);
%         Y = highpass(Y,3,400);
        [f,Ps(:,j)] = farg.signal.psd(Y,400);
        title(sprintf('U = %.0f $ms^{-1}$',Vs(i)));
    end
    hold on
    plot(f,mean(Ps,2))
    xlim([1,30])
    ylim([1e-4,1e-3]);
    grid on
    ax.YScale = "log";
    ax.FontSize = 10;
    xlabel('Freq. [Hz]')
    if i == 1
    ylabel('PSD')
    end
end