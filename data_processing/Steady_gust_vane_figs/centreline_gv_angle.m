

f = figure(1);
f.Units = "centimeters";
f.Position = [4,4,16,7];
clf;
tt = tiledlayout(1,2);
tt.Padding = "compact";
tt.TileSpacing = 'compact';

%% plot pitch with gv
jobs = [38,40,39];
load("..\SteadyData.mat")
final_data = farg.struct.filter(final_data,{{'Job',jobs}});
nexttile(1);
hold on
c = fh.colors.colorspecer(3,'qual','HighCon');
for j_i = 1:length(jobs)
    tmp_res = farg.struct.filter(final_data,{{'Job',@(x)x==jobs(j_i)},{'U_inf',@(x)x>15},{'Amplitude',@(x)~isempty(x) && x==0}});
    U_inf = round([tmp_res.U_inf]*2.5)/2.5;
    yy = [tmp_res.pitch];
%     yy = [tmp_res.yaw];
    p = plot([tmp_res.U_inf],yy,'^-.');
    p.LineWidth = 1.25;
    p.Color = c(j_i,:);
    p.MarkerFaceColor = c(j_i,:);
    p.DisplayName = sprintf('Gust Vanes, %.0f mm',tmp_res(1).x);
%     p.MarkerFaceColor = c(j_i,:);
end

%% plot pitch without gust vanes
jobs = [8,3,10];
load("..\SteadyData.mat")
final_data = farg.struct.filter(final_data,{{'Job',jobs}});

for j_i = 1:length(jobs)
    tmp_res = farg.struct.filter(final_data,{{'Job',@(x)x==jobs(j_i)},{'U_inf',@(x)x>15}});
    U_inf = round([tmp_res.U_inf]*2.5)/2.5;
    isDown = (U_inf(2:end)-U_inf(1:end-1))<0;
    idx = find(isDown,1);
    if isempty(idx)
        idx = length(isDown+1);
    end
    xx = [tmp_res(1:idx-1).U_inf];
    yy = [tmp_res(1:idx-1).pitch];
%     yy = [tmp_res(1:idx-1).yaw];
    p = plot(xx,yy,'o-');
    p.Color = c(j_i,:);
    p.MarkerFaceColor = c(j_i,:);
    p.DisplayName = sprintf('No Vanes, %.0f mm',tmp_res(1).x);
end
ylabel('Pitch Angle [deg]')
xlabel('$U_p$ [$ms^{-1}$]')
ax = gca;
ax.FontSize = 10;

%% plot yaw with gv
jobs = [38,40,39];
load("..\SteadyData.mat")
final_data = farg.struct.filter(final_data,{{'Job',jobs}});
nexttile(2);
hold on
c = fh.colors.colorspecer(3,'qual','HighCon');
for j_i = 1:length(jobs)
    tmp_res = farg.struct.filter(final_data,{{'Job',@(x)x==jobs(j_i)},{'U_inf',@(x)x>15},{'Amplitude',@(x)~isempty(x) && x==0}});
    U_inf = round([tmp_res.U_inf]*2.5)/2.5;
    yy = [tmp_res.yaw];
    p = plot([tmp_res.U_inf],yy,'^-.');
    p.LineWidth = 1.25;
    p.Color = c(j_i,:);
    p.MarkerFaceColor = c(j_i,:);
    p.DisplayName = sprintf('Gust Vanes, %.0f mm',tmp_res(1).x);
%     p.MarkerFaceColor = c(j_i,:);
end

%% plot yaw without gust vanes
jobs = [8,3,10];
load("..\SteadyData.mat")
final_data = farg.struct.filter(final_data,{{'Job',jobs}});

for j_i = 1:length(jobs)
    tmp_res = farg.struct.filter(final_data,{{'Job',@(x)x==jobs(j_i)},{'U_inf',@(x)x>15}});
    U_inf = round([tmp_res.U_inf]*2.5)/2.5;
    isDown = (U_inf(2:end)-U_inf(1:end-1))<0;
    idx = find(isDown,1);
    if isempty(idx)
        idx = length(isDown+1);
    end
    xx = [tmp_res(1:idx-1).U_inf];
    yy = [tmp_res(1:idx-1).yaw];
    p = plot(xx,yy,'o-');
    p.Color = c(j_i,:);
    p.MarkerFaceColor = c(j_i,:);
    p.DisplayName = sprintf('No Vanes, %.0f mm',tmp_res(1).x);
end
ylabel('Yaw Angle [deg]')
xlabel('$U_p$ [$ms^{-1}$]')
ax = gca;
ax.FontSize = 10;
lg = legend();
lg.Layout.Tile = 'south';
lg.NumColumns = 3;
lg.Orientation = "horizontal";

exportgraphics(gcf,'bin\gv_centre_ang.pdf','ContentType','vector');

