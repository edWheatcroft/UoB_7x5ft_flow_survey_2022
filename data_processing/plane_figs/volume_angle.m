jobs = [1:3,13:24];
load("..\SteadyData.mat")
final_data = farg.struct.filter(final_data,{{'Job',jobs}});
c = fh.colors.colorspecer(3,'qual','HighCon');

%% create streamwise plot
Vs = [15,25,35];
f = figure(1);
f.Units = "centimeters";
f.Position = [4,4,15.1,4.4];
clf;
tt = tiledlayout(1,3);
tt.Padding = "compact";
tt.TileSpacing = 'compact';

for v_i = 1:3
    tmp_res = farg.struct.filter(final_data,{{'U_inf',{'tol',Vs(v_i),2.5}},{'Radius',@(x)x>0}});
    tmp_centre = farg.struct.filter(final_data,{{'U_inf',{'tol',Vs(v_i),2.5}},{'Radius',0}});
    nexttile(v_i)
    scale = (1000*4)/mean([tmp_res.U]);

    p = quiver([tmp_res.y],[tmp_res.z],[tmp_res.v]*scale,[tmp_res.w]*scale,'filled','AutoScale','off');
    hold on
    p2 = quiver(mean([tmp_centre.y]),mean([tmp_centre.z]),mean([tmp_centre.v])*scale,mean([tmp_centre.w])*scale,'AutoScale','off');
    p2.Color = 'r';

    % plot walls
    hold on
    nodes = octagon_nodes(1524,2133.6,x_fillet=885/2,y_fillet=740/2,origin=[-2133.6/2,-1524/2]);
    nodes = [nodes;nodes(1,:)];
    plot(nodes(:,1),nodes(:,2),'k-')
    title(sprintf('$U_{inf}$ = %.0f m/s',Vs(v_i)))
    %     xlim([-1 1]*1100)
    ax = gca;
    ax.FontSize = 10;
    ax.YTick = [];
    ax.XTick = [-1000;0;1000];
    ax.XTickLabel = [-1,0,1];
    ylim(convlength(2.5,'ft','m')*1e3*[-1,1])
end
exportgraphics(gcf,'bin\vol_ang.pdf','ContentType','vector');