jobs = [1:3,13:24];
load("..\SteadyData.mat")
final_data = farg.struct.filter(final_data,{{'Job',jobs}});
c = fh.colors.colorspecer(3,'qual','HighCon');

%% create colour maps
Vs = [15,25,35];
f = figure(1);
f.Units = "centimeters";
f.Position = [4,4,16,4.5];
clf;
tt = tiledlayout(1,3);
tt.Padding = "compact";
tt.TileSpacing = 'compact';

% create wall nodes / interpolation points
nodes = octagon_nodes(1524,2133.6,x_fillet=885/2,y_fillet=740/2,origin=[-2133.6/2,-1524/2]);
nodes = [nodes;nodes(1,:)];
[Y,Z] = meshgrid(linspace(-2133.6/2,2133.6/2,101),linspace(-1524/2,1524/2,101));
Ys = Y(:);
Zs = Z(:);
idx = inpolygon(Ys,Zs,nodes(:,1),nodes(:,2));

for v_i = 1:3
    tmp_res = farg.struct.filter(final_data,{{'U_inf',{'tol',Vs(v_i),1.5}}});
    nexttile(v_i)

    y = [tmp_res.y]';
    z = [tmp_res.z]';
    val = [tmp_res.turb]';
    F = scatteredInterpolant(y,z,val,'natural','none');
    val_interp = F(Y,Z);
    [~,cf] = contourf(Y,Z,val_interp,60);
    cf.LineStyle = 'none';
%     axis equal
    % plot walls
    hold on
    plot(nodes(:,1),nodes(:,2),'k-')
    title(sprintf('$U_{inf}$ = %.0f m/s',Vs(v_i)))
    clim([0.7,1.4])
    c = fh.colors.cbrewer('div','RdYlBu',3);
    cc = fh.colors.redblue(100,[0,0,1],centre=[1,1,1]);
    colormap('hot');
    colormap(flipud(colormap));
    if v_i == 3
        cb = colorbar;
        cb.Label.String = '$I$ [\%]';
        cb.Layout.Tile = "east";
        cb.Label.Interpreter = 'latex';
        cb.Label.FontSize = 10;
    end

    % plot points measured
    p =plot(y,z,'ko');
    p.MarkerFaceColor = 'k';
    p.MarkerSize = 1.5;
    ax = gca;
    ax.FontSize = 10;
    ax.YTick = [];
    ax.YTick = [];
    ax.XTick = [-1000;0;1000];
    ax.XTickLabel = [-1,0,1];
end
exportgraphics(gcf,'bin\vol_turb.pdf','ContentType','vector');