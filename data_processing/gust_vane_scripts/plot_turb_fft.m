%% save the results
load('gust_vane_scripts/TurbAmpData.mat','turb_data')
c = fh.colors.colorspecer(3,'qual','HighCon');
%% plot the results
f = figure(2);
f.Units = "centimeters";
f.Position = [4,4,16,10];
clf;
tt = tiledlayout(2,3);
tt.Padding = "compact";
tt.TileSpacing = 'compact';
nexttile(1)
hold on

Amps = [5];
delays = [0,1,2];
markers = ["o","d","s"];
lines = ["-","-","-"];


for a_i = 1:length(Amps)
    for d_i = 1:length(delays)
        tmpMeta = farg.struct.filter(turb_data,{{'V',{'tol',25,1}},{'Amp',Amps(a_i)},{'Delay',delays(d_i)}});
        ax = nexttile(d_i);
        hold on
        ax.FontSize = 10;
        p = plot([tmpMeta.f],[tmpMeta.P1U],lines(d_i),Color=c(d_i,:));
        p.MarkerFaceColor = p.Color;
        ax.YScale = "log";
        plot([tmpMeta.f],movmean([tmpMeta.P1U],100),'k-')
        %         p.Marker = markers(d_i);
        xlim([0.1,30])
        ylim([1e-4,1e-1])
%         xlabel('Freqeuncy [Hz]')
        if d_i == 1
        ylabel('$\Phi\left(I\right)$')
        end
        title(sprintf('$t_d=%.0f$s',delays(d_i)))
        ax.FontSize = 10;

        ax = nexttile(d_i+3);
        hold on
        ax.FontSize = 10;
        p = plot([tmpMeta.f],[tmpMeta.P1w],lines(d_i),Color=c(d_i,:));
        p.MarkerFaceColor = p.Color;
        ax.YScale = "log";
        plot([tmpMeta.f],movmean([tmpMeta.P1w],100),'k-')
        xlim([0.1,30])
        ylim([1e-5,2e-3])
        xlabel('Freqeuncy [Hz]')
        if d_i == 1
        ylabel('$\Phi\left(I_w\right)$')
        end
        ax.FontSize = 10;
    end

end

exportgraphics(gcf,'bin\turb_fft.pdf','ContentType','vector');
% lg = legend();
% lg.FontSize = 10;
% lg.Interpreter = "latex";
% lg.Layout.Tile = 'south';
% lg.Orientation = "horizontal";
%
% exportgraphics(gcf,'bin\gust_amp.pdf','ContentType','vector');
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




