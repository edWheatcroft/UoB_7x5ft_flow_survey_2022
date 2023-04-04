jobs = [34:36];
load("..\SteadyData.mat")
final_data = farg.struct.filter(final_data,{{'Job',jobs}});
c = fh.colors.colorspecer(3,'qual','HighCon');

%% create colour maps
Vs = [15,25,35];
f = figure(1);
f.Units = "centimeters";
f.Position = [4,4,16,5.75];
clf;
tt = tiledlayout(1,3);
tt.Padding = "compact";
tt.TileSpacing = 'compact';

% create wall nodes / interpolation points
nodes = octagon_nodes(1524,2133.6,x_fillet=885/2,y_fillet=740/2,origin=[-2133.6/2,-1524/2]);
nodes = [nodes;nodes(1,:)];
[Y,Z] = meshgrid(linspace(-2.1336/2,2.1336/2,101)*1000,linspace(-1.524/2,1.524/2,101)*1000);
Ys = Y(:);
Zs = Z(:);
idx = inpolygon(Ys,Zs,nodes(:,1),nodes(:,2));

for v_i = 1:3
    rad = [300,500,700];
    z_p = [];
    val_p = [];
    z_s = [];
    val_s = [];
    for r_i =1:3
        tmp_port = farg.struct.filter(final_data,{{'U_inf',{'tol',Vs(v_i),1.5}},{'Radius',rad(r_i)},{'Roll',@(x)x>0}});
        tmp_star = farg.struct.filter(final_data,{{'U_inf',{'tol',Vs(v_i),1.5}},{'Radius',rad(r_i)},{'Roll',@(x)x<0}});
        nexttile(v_i)

        z_p = [z_p;[tmp_port.z]'];
        z_s = [z_s;[tmp_star.z]'];
        val_p = [val_p;[tmp_port.turb]'];
        val_s = [val_s;[tmp_star.turb]'];


    end
    z = [z_p;z_s];
    val = [val_p;val_s];
    idx_up = val>1.5 & z>0 & abs(z)<400;
    idx_down = val>1.5 & z<0 & abs(z)<400;
    wake_up = mean(z(idx_up))
    wake_down = mean(z(idx_down))
    wake_up_width = max(z(idx_up))- min(z(idx_up))
    wake_down_width = max(z(idx_down))- min(z(idx_down))
    

    p = plot([0,3],[wake_up,wake_up]./1000,'k-.');
    p.Annotation.LegendInformation.IconDisplayStyle = 'off';
    hold on
    p = plot([0,3],[wake_down,wake_down]./1000,'k-.');
    p.DisplayName = 'Wake Location';
    p = plot(val_p,z_p./1000,'<');
    p.Color = c(1,:);
    p.MarkerFaceColor = c(1,:);
    p.MarkerSize = 5;
    p.DisplayName = 'Port Measurment';
    p = plot(val_s,z_s./1000,'>');
    p.Color = c(2,:);
    p.MarkerFaceColor = c(2,:);
    p.MarkerSize = 5;
    p.DisplayName = 'Starboard Measurment';
    if v_i ==1
        ylabel('Z [m]')
    end
    %     xlabel('$\Delta U$ [$ms^{-1}$]')
    title(sprintf('$U_p$ = %.0f m/s',Vs(v_i)))
    %     xlim([-1.5,2]);
    ylim([-0.6,0.6])
%     yticks(round([-500,wake_down,0,wake_up,500]))
    if v_i == 2
        xlabel('Turb. Intensity [\%]')
    end
    ax = gca;
    ax.FontSize = 10;
end
% tt.XLabel.String = ''
nexttile(1);
lg = legend();
lg.Layout.Tile = 'south';
lg.FontSize = 10;
lg.Orientation = "horizontal";
exportgraphics(gcf,'bin\gv_wake_z.pdf','ContentType','vector');