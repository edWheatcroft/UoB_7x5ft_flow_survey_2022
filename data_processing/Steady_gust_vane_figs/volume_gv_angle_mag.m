jobs = [34,35,36];
load("..\SteadyData.mat")
final_data = farg.struct.filter(final_data,{{'Job',jobs}});
c = fh.colors.colorspecer(3,'qual','HighCon');

%% create streamwise plot
Vs = [15,25,35];
f = figure(1);
f.Units = "centimeters";
f.Position = [4,4,16,4.4];
clf;
tt = tiledlayout(1,3);
tt.Padding = "compact";
tt.TileSpacing = 'compact';

% create wall nodes / interpolation points
nodes = octagon_nodes(1524,2133.6,x_fillet=885/2,y_fillet=740/2,origin=[-2133.6/2,-1524/2]);
nodes = [nodes;nodes(1,:)]./1000;
[Y,Z] = meshgrid(linspace(-2.1336/2,2.1336/2,101),linspace(-1.524/2,1.524/2,101));
Ys = Y(:);
Zs = Z(:);
idx = inpolygon(Ys,Zs,nodes(:,1),nodes(:,2));

for v_i = 1:3
    tmp_res = farg.struct.filter(final_data,{{'U_inf',{'tol',Vs(v_i),1.5}}});
    nexttile(v_i)

    y = [tmp_res.y]'./1000;
    z = [tmp_res.z]'./1000;
    val = abs(atand(sqrt([tmp_res.w].^2 + [tmp_res.v].^2)./[tmp_res.u]))';
    F = scatteredInterpolant(y,z,val,'natural','none');
    val_interp = F(Y,Z);
    contourf(Y,Z,val_interp,10);
    % plot walls
    hold on
    plot(nodes(:,1),nodes(:,2),'k-')
    title(sprintf('$U_{inf}$ = %.0f m/s',Vs(v_i)))
    clim([0,2])
    c = fh.colors.cbrewer('div','RdYlBu',3);
    cc = fh.colors.redblue(100,[0,0,1],centre=[1,1,1]);
    colormap('hot');
    %     clim([0,2])
    %     clim([-2,1.5]);
    if v_i == 3
        cb = colorbar;
        cb.Layout.Tile = "east";
        cb.Label.String = "Abs. Angle [deg]";
%         cb.Label.Interpreter = 'latex';
        cb.Label.FontSize = 10;
    end
    if v_i == 1
    ylabel('Y [m]')
    end
    xlim([-0.75,0.75])
    ylim([-0.75,0.75])

    % plot points measured
    p =plot(y,z,'ko');
    p.MarkerFaceColor = 'k';
    p.MarkerSize = 1.5;
end

copygraphics(gcf,'ContentType','vector');
exportgraphics(gcf,'bin\gv_vol_ang_mag.pdf','ContentType','vector');