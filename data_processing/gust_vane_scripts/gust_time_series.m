jobs = [40];
load("..\TimeSeriesData200.mat")
final_data = farg.struct.filter(final_data,{{'Job',jobs}});
c = fh.colors.colorspecer(3,'qual','HighCon');
final_data = final_data(2:end);

%% get time series
amp = [12,8,4];
% Freqs = unique([final_data.Frequency]);
Freqs = 10;
U_p = 25; %[15,20,25,30]
U = 1.052*U_p + 0.258;


f = figure(2);
f.Units = "centimeters";
f.Position = [4,4,16,4.5];
clf;
tt = tiledlayout(1,3);
tt.Padding = "compact";
tt.TileSpacing = 'compact';


for a_i = 1:length(amp)
    tmp_res = farg.struct.filter(final_data,{{'Frequency',Freqs},{'Amplitude',amp(a_i)},{'U',{'tol',U,1}}});
    
    t = tmp_res(1).ti;
    V = tmp_res(1).Vi - [zeros(length(t),1),tmp_res(1).Vmean(:,2:3)];
    %reallign peak to 1
    [~,idx] = max(V(:,3));
    t = t - t(idx);
    idx = t>=-0.5;
    t = t(idx);
    V = V(idx,:);
    
    %plot
    nexttile(1);
    hold on
    p = plot(t,V(:,1));
    p.Color = c(a_i,:);
    p.LineWidth = 1.2;
    xlim([0 3])
    xlabel('Time [s]')
    ylabel('$\Delta u$ [m/s]')
    nexttile(2);
    hold on
    p = plot(t,V(:,3));
    p.Color = c(a_i,:);
    p.LineWidth = 1.2;
    xlim([0 3])
    xlabel('Time [s]')
    ylabel('$\Delta w$ [m/s]')
    nexttile(3);
    hold on
    p = plot(t,vecnorm(V')');
    p.Color = c(a_i,:);
    p.LineWidth = 1.2;
    p.DisplayName = sprintf('%.0f deg',amp(a_i));
    xlabel('Time [s]')
    xlim([0 3])
    ylabel('V [m/s]')
end

for i = 1:3
    ax = nexttile(i);
    xlim([-0.25,0.25])
    ax.FontSize = 10;
end
lg = legend();
lg.FontSize = 10;
lg.Layout.Tile = "east";
lg.Orientation = "vertical";

exportgraphics(gcf,'bin\gust_ex.pdf','ContentType','vector');


function out = MC1(t,amp,f,offset)
out = zeros(size(t));
t_i = t-offset;
idx = t_i>0 & t_i <1/f;
out(idx) = 1/2*amp*(1-cos(2*pi*f*t_i(idx)));
end
