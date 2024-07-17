jobs = [1:3];
load("..\SteadyData.mat")
final_data = farg.struct.filter(final_data,{{'Job',jobs}});
c = fh.colors.colorspecer(3,'qual','HighCon');

%% plot delta V

f = figure(1);
f.Units = "centimeters";
f.Position = [4,4,14,7];
clf;
tt = tiledlayout(1,1);
tt.Padding = "compact";
tt.TileSpacing = 'compact';
nexttile(1);
hold on;
up = [];
up_x = [];
down = [];
down_x = [];
for j_i = 1:length(jobs)
    tmp_res = farg.struct.filter(final_data,{{'Job',@(x)x==jobs(j_i)},{'U_inf',@(x)x>0}});
    U_inf = round([tmp_res.U_inf]*2.5)/2.5;
    isDown = (U_inf(2:end)-U_inf(1:end-1))<0;
    idx = find(isDown,1);
    up = [up,[tmp_res(1:idx-1).U]-[tmp_res(1:idx-1).U_inf]];
    up_x = [up_x,[tmp_res(1:idx-1).U_inf]];
    p = plot([tmp_res(1:idx-1).U_inf],[tmp_res(1:idx-1).U]-[tmp_res(1:idx-1).U_inf],'^-');
    p.Color = c(j_i,:);
    p.MarkerFaceColor = c(j_i,:);
    p.DisplayName = sprintf('Incresing Speed - Repeat %.0f',j_i);
    p.Annotation.LegendInformation.IconDisplayStyle = 'off';

    down = [down,[tmp_res(idx:end).U]-[tmp_res(idx:end).U_inf]];
    down_x = [down_x,[tmp_res(idx:end).U_inf]];
    p = plot([tmp_res(idx:end).U_inf],[tmp_res(idx:end).U]-[tmp_res(idx:end).U_inf],'v-');
    p.Color = c(j_i,:);
    p.DisplayName = sprintf('Reducing Speed - Repeat %.0f',j_i);
    p.Annotation.LegendInformation.IconDisplayStyle = 'off';
%     p.MarkerFaceColor = c(j_i,:);
end
% work out std's
x_bin = 2.5:2.5:50;
[up_std] = bin_data(up_x,up,x_bin,@nanstd);
[down_std] = bin_data(down_x,down,x_bin,@nanstd);
[total_std] = bin_data([down_x,up_x],[down,up],x_bin,@nanstd);
[total_mean] = bin_data([down_x,up_x],[down,up],x_bin,@nanmean);
pVal = polyfit(x_bin(~isnan(total_mean) & x_bin>15),total_mean(~isnan(total_mean)& x_bin>15),1);
xs = 0:0.1:50;
plot(xs,polyval(pVal,xs),'k-.','LineWidth',1.5,'DisplayName','Best Fit');
ys = [down,up];
xs = [down_x,up_x];
idx = xs>=15;
disp(nanstd(ys(idx) - polyval(pVal,xs(idx))))
disp(pVal)




ylabel('$U-U_p$ [m/s]')
xlabel('$U_p$ [m/s]')
ax = gca;
ax.FontSize = 10;



plot(nan,nan,'^-','Color',[0.6,0.6,0.6],'MarkerFaceColor',[0.6,0.6,0.6],'DisplayName','Increasing Speed');
plot(nan,nan,'v-','Color',[0.6,0.6,0.6],'DisplayName','Decreasing Speed');
lg = legend;
lg.FontSize = 10;
lg.Location = 'northwest';
xlim([0,55])
ylim([0.6,1.8])


% Create arrow
annotation('arrow',[0.412361111111111 0.540243055555556],...
    [0.497350694444444 0.639461805555556]);

% Create arrow
annotation('arrow',[0.755875496031746 0.632403273809524],...
    [0.463279771727172 0.303324910616061]);

exportgraphics(gcf,'bin\centre_v.pdf','ContentType','vector');
copygraphics(gcf);

disp(mean([final_data.U]-[final_data.U_inf]));
disp(std([final_data.U]-[final_data.U_inf]));
disp(mean(up)-mean(down));
disp(nanmean(total_std));
disp(nanmean(up_std));
disp(nanmean(down_std));
