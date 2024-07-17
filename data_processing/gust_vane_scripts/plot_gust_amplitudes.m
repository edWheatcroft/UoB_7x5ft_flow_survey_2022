%% save the results
load('gust_vane_scripts/GustAmpData.mat','gust_data')
c = fh.colors.colorspecer(4,'qual','Colorblind');
%% plot the results
f = figure(2);
f.Units = "centimeters";
f.Position = [4,4,16,11];
clf;
tt = tiledlayout(2,2);
tt.Padding = "compact";
tt.TileSpacing = 'compact';

Vs = [15,20,25,30];
Amps = [4,8,12,15];
Fs = [2,3.5,5,7.5,10,12.5,15];


for v_i = 1:length(Vs)
    nexttile(v_i)
    hold on
    for a_i = 1:length(Amps)
        tmpMeta = farg.struct.filter(gust_data,{{'V',Vs(v_i)},{'Amp',Amps(a_i)},{'F',Fs},{'x',0}});
        p = errorbar([tmpMeta.F],[tmpMeta.w],[tmpMeta.w_min],[tmpMeta.w_max]);
        p.Color = c(a_i,:);
        p.Annotation.LegendInformation.IconDisplayStyle = "off";
        p = plot([tmpMeta.F],[tmpMeta.w],'o',Color=c(a_i,:));
        p.MarkerFaceColor = p.Color;
        p.DisplayName = sprintf('$\\theta_g$ = %.0f deg',Amps(a_i));
    end
    xlabel('Gust Freq. [Hz]')
    ylabel('$w_g$ [m/s]')
    title(sprintf('$U_p$ = %.0f$ ms^{-1}$',Vs(v_i)))
    ylim([0,6])
    ax = gca;
    ax.FontSize = 10;
end
lg = legend();
lg.FontSize = 10;
lg.Interpreter = "latex";
lg.Layout.Tile = 'south';
lg.Orientation = "horizontal";

exportgraphics(gcf,'bin\gust_amp.pdf','ContentType','vector');
% %% figure out family amplitudes
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




