jobs = [1:3,13:24];
load("..\SteadyData.mat")
final_data = farg.struct.filter(final_data,{{'Job',jobs}});
c = fh.colors.colorspecer(3,'qual','HighCon');

%% create colour maps
Vs = 25;
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
[Y,Z] = meshgrid(linspace(-2.1336/2,2.1336/2,101)*1000,linspace(-1.524/2,1.524/2,101)*1000);
Ys = Y(:);
Zs = Z(:);
idx = inpolygon(Ys,Zs,nodes(:,1),nodes(:,2));

for i = 1:3
    tmp_res = farg.struct.filter(final_data,{{'U_inf',{'tol',Vs,1.5}},{'Radius',@(x)abs(x)>0.05}});
    nexttile(i)
    hold on

    y = [tmp_res.y]';
    z = [tmp_res.z]';
    switch i
        case 1
            val = [tmp_res.Delta_U]';
            title('a) $\Delta U$ [$ms^{-1}$]')
        case 2
            val = atan2d([tmp_res.w],[tmp_res.u])';
            title('b) Pitch Angle [deg]')
        case 3
            val = atan2d([tmp_res.v],[tmp_res.u])';
            title('c) Yaw Angle [deg]')
    end
    
    F = scatteredInterpolant(y,z,val,'natural','none');
    val_interp = F(Y,Z);
    [~,p] = contourf(Y,Z,val_interp,20);
    p.LineStyle = "none";
    
    plot(nodes(:,1),nodes(:,2),'k-')
    
    clim([-2,2])
    cs = fh.colors.colorspecer(4,"qual","Colorblind");
    c = fh.colors.redblue(21,start=cs(1,:),finish=cs(4,:));
%     cc = fh.colors.redblue(100,[-1,0,1.5],centre=c(2,:));
    colormap(c);
    if i == 3
        cb = colorbar;
%         cb.Label.String = '$\Delta U$ [$ms^{-1}$]';
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
exportgraphics(gcf,'bin\vol_v25_roll_fig.pdf','ContentType','vector');