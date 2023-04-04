%% save the results
load('gust_vane_scripts/TurbAmpData.mat','turb_data')
c = fh.colors.colorspecer(3,'qual','HighCon');
%% plot the results
f = figure(2);
f.Units = "centimeters";
f.Position = [4,4,16,7];
clf;
tt = tiledlayout(1,3);
tt.Padding = "compact";
tt.TileSpacing = 'compact';
nexttile(1)
hold on

Amps = [2.5,5];
delays = [0,1,2];
markers = ["d","s","o"];
lines = ["-","--","-."];


for a_i = 1:length(Amps)
    for d_i = 1:length(delays)
        tmpMeta = farg.struct.filter(turb_data,{{'Amp',Amps(a_i)},{'Delay',delays(d_i)}});
        ax = nexttile(1);
        ax.FontSize = 10;
        p = plot([tmpMeta.V],[tmpMeta.U_rms],lines(d_i),Color=c(d_i,:));
        if a_i == 2; p.MarkerFaceColor = p.Color;end;
        p.Marker = markers(d_i);
        p.DisplayName = sprintf('$\\theta_t=%.1f$ deg, $t_d=%.0f$s',Amps(a_i),delays(d_i));
        %         p.DisplayName = sprintf('$\\theta_g$ = %.0f deg',Amps(a_i));
        xlabel('Velocity [$ms^{-1}$]')
        ylabel('RMS$\left(I\right)$ [\%]')
        ax = nexttile(2);
        ax.FontSize = 10;
        hold on
        p = plot([tmpMeta.V],[tmpMeta.u_rms],lines(d_i),Color=c(d_i,:));
        if a_i == 2; p.MarkerFaceColor = p.Color;end;
        p.Marker = markers(d_i);
        p.DisplayName = sprintf('$\\theta_t=%.1f$ deg, $t_d=%.0f$s',Amps(a_i),delays(d_i));
        xlabel('Velocity [$ms^{-1}$]')
        ylabel('RMS$\left(I_u\right)$ [\%]')
        ax = nexttile(3);
        ax.FontSize = 10;
        hold on
        p = plot([tmpMeta.V],[tmpMeta.w_rms],lines(d_i),Color=c(d_i,:));
        if a_i == 2; p.MarkerFaceColor = p.Color;end;
        p.Marker = markers(d_i);
        p.DisplayName = sprintf('$\\theta_t=%.1f$ deg, $t_d=%.0f$s',Amps(a_i),delays(d_i));
        xlabel('Velocity [$ms^{-1}$]')
        ylabel('RMS$\left(I_w\right)$ [\%]')
        ylim([0.5,2.5])
    end

end

%     title(sprintf('U = %.0f$ ms^{-1}$',Vs(v_i)))
%     ylim([0,6])
ax = gca;
ax.FontSize = 10;
lg = legend();
lg.FontSize = 10;
lg.Interpreter = "latex";
lg.Layout.Tile = 'south';
lg.Orientation = "horizontal";
lg.NumColumns = 3;
exportgraphics(gcf,'bin\turb_amp.pdf','ContentType','vector');



% % %% figure out family amplitudes
% Fsg = linspace(2,15,8);
% Amps = [linspace(10,5,8);linspace(15,10,8);linspace(20,15,8)];
% V = 25;
% gust_amp = zeros(size(Amps));
%
% for i = 1:length(Fsg)
%
%     Fi = Fsg(i);
%     idx = find(Fs>=Fi,1);
%     if Fi == Fs(idx)
%         tmpMeta = farg.struct.filter(gust_data,{{'V',V},{'F',Fi}});
%         p = polyfit([tmpMeta.Amp],[tmpMeta.w],1);
%         for j = 1:size(Amps,1)
%             gust_amp(j,i) = polyval(p,Amps(j,i));
%         end
%     else
%         tmpMeta = farg.struct.filter(gust_data,{{'V',V},{'F',Fs(idx-1)}});
%         p1 = polyfit([tmpMeta.Amp],[tmpMeta.w],1);
%         tmpMeta = farg.struct.filter(gust_data,{{'V',V},{'F',Fs(idx)}});
%         p2 = polyfit([tmpMeta.Amp],[tmpMeta.w],1);
%         delta = (Fi-Fs(idx-1))/(Fs(idx)-Fs(idx-1));
%         for j = 1:size(Amps,1)
%             v1 = polyval(p1,Amps(j,i));
%             v2 = polyval(p2,Amps(j,i));
%             gust_amp(j,i) = v1 + (v2-v1)*delta;
%         end
%     end
% end
%
% c= fh.colors.linspecer(4,'colorblind');
% figure(2);clf;
%
% for i = 1:size(Amps,1)
%     plt_obj = plot(Fsg,gust_amp(i,:));
%     plt_obj.Color = c(i,:);
%     plt_obj.LineWidth = 1.5;
%     plt_obj.Marker =  "o";
%     plt_obj.MarkerFaceColor = c(i,:);
%     plt_obj.DisplayName = sprintf('Family %.0f',i);
%     hold on;
% end
% xlabel('Gust Frequency [Hz]')
% ylabel('Peak Gust vertical Velocity [m/s]')




