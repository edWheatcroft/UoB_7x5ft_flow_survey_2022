jobs = [8,3,10];
load("..\SteadyData.mat")
final_data = farg.struct.filter(final_data,{{'Job',jobs}});
c = fh.colors.colorspecer(3,'qual','HighCon');

f = figure(1);
f.Units = "centimeters";
f.Position = [4,4,16,9];
clf;
tt = tiledlayout(2,2);
tt.Padding = "compact";
tt.TileSpacing = 'compact';

%% turb
nexttile(3)
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
    if isempty(idx)
        idx = length(isDown+1);
    end
    xx = [tmp_res(1:idx-1).U_inf];
    p = errorbar(xx,[tmp_res(1:idx-1).turb],ones(size(xx))*0.02*4.3/(sqrt(3)));
    p.Color = c(j_i,:);
    p.MarkerFaceColor = c(j_i,:);
    p.DisplayName = sprintf('%.0f mm',tmp_res(1).x);
end
ylabel('I [\%] [deg]')
xlabel('$U_p$ [$ms^{-1}$]')

ax = gca;
ax.FontSize = 10;
grid on

%% pitch
nexttile(2)
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
    if isempty(idx)
        idx = length(isDown+1);
    end
    up = [up,[tmp_res(1:idx-1).pitch]];
    up_x = [up_x,[tmp_res(1:idx-1).U_inf]];
%     p = plot([tmp_res(1:idx-1).U_inf],[tmp_res(1:idx-1).U]-[tmp_res(1:idx-1).U_inf],'o-');
    xx = [tmp_res(1:idx-1).U_inf];
    p = errorbar(xx,[tmp_res(1:idx-1).yaw],ones(size(xx))*0.08*4.3/(sqrt(3)));
    p.Color = c(j_i,:);
    p.MarkerFaceColor = c(j_i,:);
    p.DisplayName = sprintf('%.0f mm',tmp_res(1).x);
end
ylabel('yaw [deg]')
xlabel('$U_p$ [$ms^{-1}$]')

ax = gca;
ax.FontSize = 10;
grid on

%% Delta U
nexttile(1)
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
    if isempty(idx)
        idx = length(isDown+1);
    end
    up = [up,[tmp_res(1:idx-1).U]-[tmp_res(1:idx-1).U_inf]];
    up_x = [up_x,[tmp_res(1:idx-1).U_inf]];
%     p = plot([tmp_res(1:idx-1).U_inf],[tmp_res(1:idx-1).U]-[tmp_res(1:idx-1).U_inf],'o-');
    xx = [tmp_res(1:idx-1).U_inf];
    p = errorbar(xx,[tmp_res(1:idx-1).U]-[tmp_res(1:idx-1).U_inf],ones(size(xx))*0.02*4.3/(sqrt(3)));
    p.Color = c(j_i,:);
    p.MarkerFaceColor = c(j_i,:);
    p.DisplayName = sprintf('%.0f mm',tmp_res(1).x);
end

lg = legend;
lg.FontSize = 10;
lg.Location = 'northwest';
grid

ylabel('$U-U_p$ [$ms^{-1}$]')

%% yaw
nexttile(4)
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
    if isempty(idx)
        idx = length(isDown+1);
    end
    up = [up,[tmp_res(1:idx-1).yaw]];
    up_x = [up_x,[tmp_res(1:idx-1).U_inf]];
%     p = plot([tmp_res(1:idx-1).U_inf],[tmp_res(1:idx-1).U]-[tmp_res(1:idx-1).U_inf],'o-');
    xx = [tmp_res(1:idx-1).U_inf];
    p = errorbar(xx,[tmp_res(1:idx-1).yaw],ones(size(xx))*0.07*4.3/(sqrt(3)));
    p.Color = c(j_i,:);
    p.MarkerFaceColor = c(j_i,:);
    p.DisplayName = sprintf('%.0f mm',tmp_res(1).x);
end
ylabel('yaw [deg]')
xlabel('$U_p$ [$ms^{-1}$]')

ax = gca;
ax.FontSize = 10;
grid on

exportgraphics(gcf,'bin\centre_x.pdf','ContentType','vector');