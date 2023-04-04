jobs = [34,35,36];
load("..\SteadyData.mat")
final_data = farg.struct.filter(final_data,{{'Job',jobs}});
c = fh.colors.colorspecer(3,'qual','HighCon');

%% create streamwise plot
Vs = [15,25,35];
f = figure(1);
f.Units = "centimeters";
f.Position = [4,4,14.5,4.4];
clf;
tt = tiledlayout(1,3);
tt.Padding = "compact";
tt.TileSpacing = 'compact';
for v_i = 1:3
    tmp_res = farg.struct.filter(final_data,{{'U_inf',{'tol',Vs(v_i),2.5}},{'Radius',@(x)x>0}});
    tmp_centre = farg.struct.filter(final_data,{{'U_inf',{'tol',Vs(v_i),2.5}},{'Radius',0}});
    nexttile(v_i)
    scale = (4)/mean([tmp_res.U]);

    p = quiver([tmp_res.y]./1000,[tmp_res.z]./1000,[tmp_res.v]*scale,[tmp_res.w]*scale,'filled','AutoScale','off');
    hold on
    p2 = quiver(mean([tmp_centre.y])./1000,mean([tmp_centre.z])./1000,mean([tmp_centre.v])*scale,mean([tmp_centre.w])*scale,'AutoScale','off');
    p2.Color = 'r';
%     axis equal
%     axis manual

    % plot walls
    nodes = octagon_nodes(1524,2133.6,x_fillet=885/2,y_fillet=740/2,origin=[-2133.6/2,-1524/2]);
    nodes = [nodes;nodes(1,:)]./1000;
    plot(nodes(:,1),nodes(:,2),'k-')
    title(sprintf('$U_{inf}$ = %.0f m/s',Vs(v_i)))
    xlim([-0.75,0.75])
    ylim([-0.75,0.75])
    if v_i == 1
        ylabel('Y [m]')
    end

    %     xlim([-1 1]*1100)
end
nexttile(1)
x_lim = xlim;
y_lim = ylim;
for i = 2:3
    nexttile(i)
    xlim(x_lim);
    ylim(y_lim);
end

exportgraphics(gcf,'bin\gv_vol_ang.pdf','ContentType','vector');