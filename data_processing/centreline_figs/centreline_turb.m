jobs = [1:3];
load("..\SteadyData.mat")
final_data = farg.struct.filter(final_data,{{'Job',jobs}});
c = fh.colors.colorspecer(3,'qual','HighCon');

%% plot delta V

f = figure(1);
f.Units = "centimeters";
f.Position = [4,4,16,8];
clf;
tt = tiledlayout(2,2);
tt.Padding = "compact";
tt.TileSpacing = 'compact';


names = ["turb","turb_u","turb_v","turb_w"];
Dname = ["$I$","$I_x$","$I_y$","$I_z$"];
for i = 1:length(names)
    nexttile(i);
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
        y = [tmp_res(1:idx-1).(names(i))];
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
        y = [tmp_res(idx:end).(names(i))];
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
    ylim([0.4,1.1])
    grid
    
    ylabel(Dname(i)+" [\%]")
    if i>2
    xlabel('$U_p$ [m/s]')
    end
    f = gcf;
    ax = gca;
    ax.FontSize = 10;
%     grid minor
if i == 1
    lg = legend;
    lg.FontSize = 10;
    lg.Layout.Tile = 'south';
    lg.Orientation = "horizontal";
end
    xlim([0,55])
end

exportgraphics(gcf,'bin\centre_turb.pdf','ContentType','vector');
copygraphics(gcf,'ContentType','vector');

disp(mean([up,down]))
disp(std([up,down]))
disp(mean(up)-mean(down))
disp(nanmean(total_std))
disp(nanmean(up_std))
disp(nanmean(down_std))
