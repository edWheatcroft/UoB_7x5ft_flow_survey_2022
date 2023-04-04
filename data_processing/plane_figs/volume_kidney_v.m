jobs = [25:30];
load("..\SteadyData.mat")
final_data = farg.struct.filter(final_data,{{'Job',jobs}});
c = fh.colors.colorspecer(3,'qual','HighCon');
for i = 1:length(final_data)
    final_data(i).clean = final_data(i).Job>=28;
end

%% create colour maps
xs = [0,1];
f = figure(2);
f.Units = "centimeters";
f.Position = [4,4,16,4.5];
clf;
tt = tiledlayout(1,2);
tt.Padding = "compact";
tt.TileSpacing = 'compact';

% create wall nodes / interpolation points
nodes = octagon_nodes(1524,2133.6,x_fillet=885/2,y_fillet=740/2,origin=[-2133.6/2,-1524/2]);
nodes = [nodes;nodes(1,:)];
[Y,Z] = meshgrid(linspace(-2.1336/2,2.1336/2,101)*1000,linspace(-1.524/2,1.524/2,101)*1000);
Ys = Y(:);
Zs = Z(:);
idx = inpolygon(Ys,Zs,nodes(:,1),nodes(:,2));

for x_i = 1:2
    tmp_res = farg.struct.filter(final_data,{{'U_inf',{'tol',25,2.5}},{'clean',xs(x_i)}});
    nexttile(x_i)

    y = [tmp_res.y]';
    z = [tmp_res.z]';
        val = [tmp_res.Delta_U]';
%     val = abs(atand(sqrt([tmp_res.w].^2 + [tmp_res.v].^2)./[tmp_res.u]))';
    %     val = [tmp_res.w]';
    %     val = (sqrt([tmp_res.w].^2 + [tmp_res.v].^2)./[tmp_res.U_inf])'*100;
    %     val = [tmp_res.flow_angle]';
    %     val = [tmp_res.turb]';
    %     val = ([tmp_res.Delta_U]./[tmp_res.U_inf])'*100;
    %     val = [tmp_res.Delta_U]';
    F = scatteredInterpolant(y,z,val,'natural','none');
    val_interp = F(Y,Z);
    contourf(Y,Z,val_interp);
    
    % plot walls
    hold on
    plot(nodes(:,1),nodes(:,2),'k-')
    %     title(sprintf('Tunnel Velocity = %.0f m/s',Vs(v_i)))
    %     clim([-3,1.5])
    %     clim([0.4,1])
    %     clim([-2,1.5]);
    clim([-2,2])
    if x_i == 2
        cb = colorbar;
        cb.Layout.Tile = "east";
        cb.Label.String = "$\Delta U$";
        cb.Label.Interpreter = 'latex';
        colormap('hot');
    end
    if xs(x_i)
        title('Kidney Bean Roof')
    else
        title('Clean Roof')
    end
    ylabel('Y [mm]')


    % plot points measured
    p =plot(y,z,'ko');
    p.MarkerFaceColor = 'k';
    p.MarkerSize = 1.5;
    axis equal
    ax = gca;
    ax.FontSize = 10;
end
exportgraphics(gcf,'bin\vol_kid_v.pdf','ContentType','vector');