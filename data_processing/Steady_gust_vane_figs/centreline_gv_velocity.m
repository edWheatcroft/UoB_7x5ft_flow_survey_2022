jobs = [38,40,39];
load("..\SteadyData.mat")
final_data = farg.struct.filter(final_data,{{'Job',jobs}});
c = fh.colors.colorspecer(3,'qual','HighCon');

%% plot delta V

f = figure(1);
f.Units = "centimeters";
f.Position = [4,4,14,6];
clf;
tt = tiledlayout(1,1);
tt.Padding = "compact";
tt.TileSpacing = 'compact';
nexttile(1);
hold on;
up = [];
up_x = [];
for j_i = 1:length(jobs)
    tmp_res = farg.struct.filter(final_data,{{'Job',@(x)x==jobs(j_i)},{'U_inf',@(x)x>15},{'Amplitude',@(x)~isempty(x) && x==0}});
    U_inf = round([tmp_res.U_inf]*2.5)/2.5;
    up = [up,[tmp_res.U]-[tmp_res.U_inf]];
    up_x = [up_x,[tmp_res.U_inf]];
    p = plot([tmp_res.U_inf],[tmp_res.U]-[tmp_res.U_inf],'^-.');
    p.LineWidth = 1.25;
    p.Color = c(j_i,:);
    p.MarkerFaceColor = c(j_i,:);
    p.DisplayName = sprintf('Gust Vanes, %.0f mm',tmp_res(1).x);
%     p.MarkerFaceColor = c(j_i,:);
end
% work out std's
x_bin = 2.5:2.5:50;
[total_mean] = bin_data([up_x],[up],x_bin,@nanmean);
pVal1 = polyfit(x_bin(~isnan(total_mean) & x_bin>15),total_mean(~isnan(total_mean)& x_bin>15),1);
xs = 0:0.1:50;
plot(xs,polyval(pVal1,xs),'k-','LineWidth',1.5,'DisplayName','Best Fit');
ys = [up];
xs = [up_x];
idx = xs>=15;
disp(nanstd(ys(idx) - polyval(pVal1,xs(idx))))
disp(pVal1)


%% plot without gust vanes
jobs = [8,2,10];
load("..\SteadyData.mat")
final_data = farg.struct.filter(final_data,{{'Job',jobs}});
c = fh.colors.colorspecer(3,'qual','HighCon');
up = [];
up_x = [];
for j_i = 1:length(jobs)
    tmp_res = farg.struct.filter(final_data,{{'Job',@(x)x==jobs(j_i)},{'U_inf',@(x)x>15}});
    U_inf = round([tmp_res.U_inf]*2.5)/2.5;
    isDown = (U_inf(2:end)-U_inf(1:end-1))<0;
    up_x = [up_x,tmp_res(~isDown).U_inf];
    up = [up,[tmp_res(~isDown).U]-[tmp_res(~isDown).U_inf]];
    p = plot([tmp_res(~isDown).U_inf],[tmp_res(~isDown).U]-[tmp_res(~isDown).U_inf],'o-');
    p.LineWidth = 1.25;
    p.Color = c(j_i,:);
    p.MarkerFaceColor = c(j_i,:);
    p.DisplayName = sprintf('No Vanes, %.0f mm',tmp_res(1).x);
end

x_bin = 2.5:2.5:50;
pVal2 = polyfit(up_x,up,1);
xs = 0:0.1:50;
p = plot(xs,polyval(pVal2,xs),'k-','LineWidth',1.5,'DisplayName','Best Fit');
p.Annotation.LegendInformation.IconDisplayStyle = 'off';
ys = [down,up];
xs = [down_x,up_x];
idx = xs>=15;
disp(nanstd(ys(idx) - polyval(pVal2,xs(idx))))
disp(pVal2)

ylabel('$U-U_p$ [$ms^{-1}$]')
xlabel('$U_p$ [$ms^{-1}$]')
ax = gca;
ax.FontSize = 10;
ax.Children = flipud(ax.Children);

lg = legend;
lg.FontSize = 10;
lg.Layout.Tile = 'east';
xlim([15,35])
ylim([0.5,2.2])

exportgraphics(gcf,'bin\gv_centre_v.pdf','ContentType','vector');
copygraphics(gcf);

disp(mean([final_data.U]-[final_data.U_inf]))
disp(std([final_data.U]-[final_data.U_inf]))
disp(pVal1)
disp(pVal2)
disp(mean(polyval(pVal1,15:25)-polyval(pVal2,15:25)))
