%% save the results
load('gust_vane_scripts/GustAmpData.mat','gust_data')
c = fh.colors.colorspecer(4,'qual','Colorblind');
%% plot the results
f = figure(2);
f.Units = "centimeters";
f.Position = [4,4,16,8];
clf;
tt = tiledlayout(1,3);
tt.Padding = "compact";
tt.TileSpacing = 'compact';

Vs = [20,25,30];
Amps = [8,15];
Fs = [2,3.5,5,7.5,10,12.5,15];
xs=[-400,0,400];
markers = ["o","d"];
for v_i = 1:length(Vs)
    ax = nexttile(v_i);
    hold on
    for a_i = 1:length(Amps)
        for x_i = 1:length(xs)
            tmpMeta = farg.struct.filter(gust_data,{{'V',Vs(v_i)},{'Amp',Amps(a_i)},{'F',Fs},{'x',xs(x_i)}});
            p = plot([tmpMeta.F],[tmpMeta.w],'o-',Color=c(x_i,:));
            if a_i == 2
                p.MarkerFaceColor = p.Color;
            end
            p.Marker = markers(a_i);
            p.Annotation.LegendInformation.IconDisplayStyle = "off";
        end
    end
    if v_i ==2
    xlabel('Gust Frequency [Hz]')
    end
    ylabel('$w_g$ [m/s]')
    ax.FontSize = 10;
end
for i = 1:length(xs)
    p = plot(nan,nan,'-',Color=c(i,:),DisplayName=sprintf('x=%.0fmm',xs(i)));
end
for i = 1:length(Amps)
    p = plot(nan,nan,markers(i),Color=[0.6,0.6,0.6],DisplayName=sprintf('Amp=%.0f deg',Amps(i)));
    if i ==2
        p.MarkerFaceColor = p.Color;
    end
end

lg = legend();
lg.FontSize = 10;
lg.Interpreter = "latex";
lg.Layout.Tile = 'south';
lg.Orientation = "vertical";
lg.NumColumns = 2;

exportgraphics(gcf,'bin\gust_amp_x.pdf','ContentType','vector');
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




