jobs = 25:30;
load("..\SteadyData.mat")
final_data = farg.struct.filter(final_data,{{'Job',jobs}});
c = fh.colors.colorspecer(3,'qual','HighCon');
for i = 1:length(final_data)
    final_data(i).isKidney = final_data(i).Job>=28;
end

%% create streamwise plot
Vs = [25];
f = figure(1);
f.Units = "centimeters";
f.Position = [4,4,16,6];
clf;
tt = tiledlayout(1,3);
tt.Padding = "compact";
tt.TileSpacing = 'compact';
isK = [false,true];
names = ["Clean","Kidney"];
for i = 1:length(isK)
    tmp_res = farg.struct.filter(final_data,{{'U_inf',{'tol',Vs,2.5}},{'Radius',@(x)x>0},{'Roll',@(x)abs(abs(x)-90)<5},{'isKidney',isK(i)}});    
    nexttile(1)
    hold on
    [~,idx] = sort([tmp_res.y]);
    tmp_res = tmp_res(idx);
    p =plot([tmp_res.y]./1000,[tmp_res.Delta_U],'o-');
    p.Color = c(i,:);
    p.MarkerFaceColor = c(i,:);
    p.MarkerSize = 3;
    p.DisplayName = names(i);
    ylabel('$\Delta U$ [$ms^{-1}$]')
    ax = gca;
    ax.FontSize = 10;
    ax.XTick = -0.8:0.4:0.8;
    xlim([-0.8,0.8])
    grid on

    nexttile(2)
    hold on
    [~,idx] = sort([tmp_res.y]);
    tmp_res = tmp_res(idx);
    p =plot([tmp_res.y]./1000,[tmp_res.pitch],'o-');
    p.Color = c(i,:);
    p.MarkerFaceColor = c(i,:);
    p.MarkerSize = 3;
    p.Annotation.LegendInformation.IconDisplayStyle = "off";
    ylabel('Pitch Angle [deg]')
    ax = gca;
    ax.FontSize = 10;
    ax.XTick = -0.8:0.4:0.8;
    xlim([-0.8,0.8])
    grid on
    xlabel('X [m]')

    nexttile(3)
    hold on
    p = plot([tmp_res.y]./1000,[tmp_res.yaw],'o-');
    p.Color = c(i,:);
    p.MarkerFaceColor = c(i,:);
    p.MarkerSize = 3;
    p.Annotation.LegendInformation.IconDisplayStyle = "off";
    ylabel('Yaw Angle [deg]')
    ax = gca;
    ax.FontSize = 10;
    ax.XAxis.MinorTickValuesMode ="manual";
    ax.XTick = -0.8:0.4:0.8;
    xlim([-0.8,0.8])
    grid on
end
tt.XLabel.FontSize = 10;

nexttile(1)
lg = legend();
lg.FontSize = 10;
lg.Layout.Tile = 'south';
lg.Orientation = "horizontal";

exportgraphics(gcf,'bin\kid_z0.pdf','ContentType','vector');