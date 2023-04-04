jobs = [25:30];
load("..\SteadyData.mat")
final_data = farg.struct.filter(final_data,{{'Job',jobs}});
c = fh.colors.colorspecer(3,'qual','HighCon');
for i = 1:length(final_data)
    final_data(i).clean = final_data(i).Job>=28;
end

%% create streamwise plot
xs = [0,1];
f = figure(1);
f.Units = "centimeters";
f.Position = [4,4,15.1,4.5];
clf;
tt = tiledlayout(1,2);
tt.Padding = "compact";
tt.TileSpacing = 'loose';
for x_i = 1:2
    tmp_res = farg.struct.filter(final_data,{{'U_inf',{'tol',25,2.5}},{'clean',xs(x_i)},{'Radius',@(x)x<710}});
    nexttile(x_i)
    quiver([tmp_res.y],[tmp_res.z],[tmp_res.v],[tmp_res.w])
    
    % plot walls
    hold on
    nodes = octagon_nodes(1524,2133.6,x_fillet=885/2,y_fillet=740/2,origin=[-2133.6/2,-1524/2]);
    nodes = [nodes;nodes(1,:)];
    plot(nodes(:,1),nodes(:,2),'k-')
    if xs(x_i)
        title('Kidney Bean Roof')
    else
        title('Clean Roof')
    end
    axis equal
    ax = gca;
    ax.FontSize = 10;
%     xlim([-1000,1000])
end
exportgraphics(gcf,'bin\vol_kid_ang.pdf','ContentType','vector');