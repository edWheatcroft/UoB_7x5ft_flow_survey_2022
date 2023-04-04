jobs = [1:3,13:24];
load("..\SteadyData.mat")
final_data = farg.struct.filter(final_data,{{'Job',jobs}});
c = fh.colors.colorspecer(3,'qual','HighCon');

%% create streamwise plot
Vs = [15,25,35];
f = figure(1);
f.Units = "centimeters";
f.Position = [4,4,16,10];
clf;
tt = tiledlayout(3,3);
tt.Padding = "compact";
tt.TileSpacing = 'compact';
for v_i = 1:3
    tmp_res = farg.struct.filter(final_data,{{'U_inf',{'tol',Vs(v_i),2.5}},{'Radius',@(x)x>0},{'Roll',@(x)abs(abs(x)-90)<5}});    
    nexttile(v_i)
    [~,idx] = sort([tmp_res.y]);
    tmp_res = tmp_res(idx);
    p =plot([tmp_res.y]./1000,[tmp_res.Delta_U],'o-');
    p.MarkerFaceColor = 'b';
    p.MarkerSize = 3;
    title(sprintf('$U_{inf}$ = %.0f m/s',Vs(v_i)))
    ylabel('$\Delta U$ [$ms^{-1}$]')
    ax = gca;
    ax.FontSize = 10;
    ax.XTick = -1:0.5:1;
    grid

    nexttile(v_i+3)
    [~,idx] = sort([tmp_res.y]);
    tmp_res = tmp_res(idx);
    p =plot([tmp_res.y]./1000,[tmp_res.pitch],'o-');
    p.MarkerFaceColor = 'b';
    p.MarkerSize = 3;
    ylabel('pitch [deg]')
    ax = gca;
    ax.FontSize = 10;
    ax.XTick = -1:0.5:1;
    grid

    nexttile(v_i+6)
    p = plot([tmp_res.y]./1000,[tmp_res.yaw],'o-');
    p.MarkerFaceColor = 'b';
    p.MarkerSize = 3;
    ylabel('yaw [deg]')
    ax = gca;
    ax.FontSize = 10;
    ax.XAxis.MinorTickValuesMode ="manual";
    ax.XTick = -1:0.5:1;
    grid on
    xlabel('X [m]')
    
end
tt.XLabel.FontSize = 10;

exportgraphics(gcf,'bin\vol_z0.pdf','ContentType','vector');