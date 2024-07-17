jobs = [1:3];
load("..\SteadyData.mat")
final_data = farg.struct.filter(final_data,{{'Job',jobs}});

f = figure(1);
f.Units = "centimeters";
f.Position = [4,4,16,6];
clf;
tt = tiledlayout(1,2);
tt.Padding = "compact";
tt.TileSpacing = 'compact';

%% plot delta V
nexttile(1)
hold on;
c = fh.colors.colorspecer(3,'qual','HighCon');
up = [];
up_x = [];
down = [];
down_x = [];
for j_i = 1:length(jobs)
    tmp_res = farg.struct.filter(final_data,{{'Job',@(x)x==jobs(j_i)},{'U_inf',@(x)x>0}});
    U_inf = round([tmp_res.U_inf]*2.5)/2.5;
    isDown = (U_inf(2:end)-U_inf(1:end-1))<0;
    idx = find(isDown,1);
    x = [tmp_res(1:idx-1).U_inf];
    y = [tmp_res(1:idx-1).pitch];
    up = [up,y];
    up_x = [up_x,x];
    p = plot(x,y,'^-');
    p.Color = c(j_i,:);
    p.MarkerFaceColor = c(j_i,:);
    if j_i == 1
        p.DisplayName = sprintf('Incresing Speed',j_i);
    else
        p.Annotation.LegendInformation.IconDisplayStyle = 'off';
    end

    x = [tmp_res(idx:end).U_inf];
    y = [tmp_res(idx:end).pitch];
    down = [down,y];
    down_x = [down_x,x];
    p = plot(x,y,'v-');
    p.Color = c(j_i,:);
    if j_i == 1
        p.DisplayName = sprintf('Reducing Speed',j_i);
    else
        p.Annotation.LegendInformation.IconDisplayStyle = 'off';
    end
%     p.MarkerFaceColor = c(j_i,:);
end
% work out std's
x_bin = 2.5:2.5:50;
[up_std] = bin_data(up_x,up,x_bin,@nanstd);
[down_std] = bin_data(down_x,down,x_bin,@nanstd);
[total_std] = bin_data([down_x,up_x],[down,up],x_bin,@nanstd);


ylabel('Pitch [deg]')
xlabel('$U_p$ [m/s]')

ax = gca;
ax.FontSize = 10;
% grid minor
lg = legend;

lg.FontSize = 10;
lg.Location = 'northeast';
xlim([0,55])

%% plot delta V

nexttile(2);
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
    x = [tmp_res(1:idx-1).U_inf];
    y = [tmp_res(1:idx-1).yaw];
    up = [up,y];
    up_x = [up_x,x];
    p = plot(x,y,'^-');
    p.Color = c(j_i,:);
    p.MarkerFaceColor = c(j_i,:);
    if j_i == 1
        p.DisplayName = sprintf('Incresing Speed',j_i);
    else
        p.Annotation.LegendInformation.IconDisplayStyle = 'off';
    end

    x = [tmp_res(idx:end).U_inf];
    y = [tmp_res(idx:end).yaw];
    down = [down,y];
    down_x = [down_x,x];
    p = plot(x,y,'v-');
    p.Color = c(j_i,:);
    if j_i == 1
        p.DisplayName = sprintf('Reducing Speed',j_i);
    else
        p.Annotation.LegendInformation.IconDisplayStyle = 'off';
    end
%     p.MarkerFaceColor = c(j_i,:);
end
% work out std's
x_bin = 2.5:2.5:50;
[up_std] = bin_data(up_x,up,x_bin,@nanstd);
[down_std] = bin_data(down_x,down,x_bin,@nanstd);
[total_std] = bin_data([down_x,up_x],[down,up],x_bin,@nanstd);

ylabel('Yaw [deg]')
xlabel('$U_p$ [m/s]')
ax = gca;
ax.FontSize = 10;
% grid minor
lg = legend;

lg.FontSize = 10;
lg.Location = 'southeast';
xlim([0,55])

exportgraphics(gcf,'bin\centre_angle.pdf','ContentType','vector');

