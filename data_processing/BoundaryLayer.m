jobs = [12:24];
%% vertical
f = figure(1);
f.Units = "centimeters";
f.Position = [4,4,10,10];
clf;
c = fh.colors.colorspecer(3,'qual','HighCon');
hold on

Vs = [15,25,35];
symbols = ["s","o","d"];
for i = 1:3
load("..\SteadyData.mat")
final_data = farg.struct.filter(final_data,{{'Job',jobs},{'y',@(x)abs(x)<150},{'U_inf',{'tol',Vs(i),1}}});
y = [final_data.y];
z = [final_data.z];
V = [final_data.U];

idx = (z+762)<200;
V = V./max(V(idx))*100;
plot(V,z+762,symbols(i),Color=c(i,:),DisplayName=sprintf('%.0f m/s',Vs(i)),MarkerFaceColor=c(i,:),LineWidth=1.5)
end

ylim([0,200])
grid on
xlabel('Percentage of Freestream Velocity [\%]')
ylabel('Distance from tunnel Floor [mm]')
lg = legend();
lg.Location = "northwest";
lg.Title.String = 'Tunnel Velocity';
lg.FontSize = 10;

ax = gca;
ax.FontSize = 10;
title('Line A')


%% horizontal
f = figure(2);
f.Units = "centimeters";
f.Position = [4,4,10,10];
clf;
c = fh.colors.colorspecer(3,'qual','HighCon');
hold on

Vs = [15,25,35];
symbols = ["s","o","d"];
for i = 1:3
load("..\SteadyData.mat")
final_data = farg.struct.filter(final_data,{{'Job',jobs},{'z',@(x)abs(x)<150},{'U_inf',{'tol',Vs(i),1}}});
y = [final_data.y];
z = [final_data.z];
V = [final_data.U];

idx = (y+1067)<200;
V = V./max(V(idx))*100;
plot(V,y+1067,symbols(i),Color=c(i,:),DisplayName=sprintf('%.0f m/s',Vs(i)),MarkerFaceColor=c(i,:),LineWidth=1.5)
end

ylim([0,200])
grid on
xlabel('Percentage of Freestream Velocity [\%]')
ylabel('Distance from tunnel wall [mm]')
lg = legend();
lg.Location = "northwest";
lg.Title.String = 'Tunnel Velocity';
lg.FontSize = 10;

ax = gca;
ax.FontSize = 10;
title('Line B')


%% fillet B

f = figure(3);
f.Units = "centimeters";
f.Position = [4,4,10,10];
clf;
c = fh.colors.colorspecer(3,'qual','HighCon');
hold on

Vs = [15,25,35];
symbols = ["s","o","d"];
load("..\SteadyData.mat")
for i = 1:length(final_data)
    final_data(i).ang = atan2d(final_data(i).y,final_data(i).z);
    final_data(i).d = sqrt(final_data(i).z.^2 + final_data(i).y.^2);
    delta_side = 1067-abs(final_data(i).y);
    delta_top = 762-abs(final_data(i).z);
    delta_fillet = zeros(1,4);
    delta_fillet(1) = point_to_line([final_data(i).y,final_data(i).z,0],[1067,365,0],[435,762,0]);
    delta_fillet(2) = point_to_line([final_data(i).y,final_data(i).z,0],[-1067,-365,0],[-435,-762,0]);
    delta_fillet(3) = point_to_line([final_data(i).y,final_data(i).z,0],[-1067,365,0],[-435,762,0]);
    delta_fillet(4) = point_to_line([final_data(i).y,final_data(i).z,0],[1067,-365,0],[435,-762,0]);
    final_data(i).dist = min([delta_side,delta_top,delta_fillet]);
end
for i = 1:3
tmp_data = farg.struct.filter(final_data,{{'Job',jobs},{'ang',@(x)x<114 & x>104},{'U_inf',{'tol',Vs(i),1}}});
d = [tmp_data.dist];
V = [tmp_data.U];
idx = (d)<200;
V = V./max(V(idx))*100;
plot(V,d,symbols(i),Color=c(i,:),DisplayName=sprintf('%.0f m/s',Vs(i)),MarkerFaceColor=c(i,:),LineWidth=1.5)
end

ylim([0,200])
grid on
xlabel('Percentage of Freestream Velocity [\%]')
ylabel('Distance from tunnel wall [mm]')
lg = legend();
lg.Location = "northwest";
lg.Title.String = 'Tunnel Velocity';
lg.FontSize = 10;
title('Fillet C')

ax = gca;
ax.FontSize = 10;


%% fillet C

f = figure(4);
f.Units = "centimeters";
f.Position = [4,4,10,10];
clf;
c = fh.colors.colorspecer(3,'qual','HighCon');
hold on

Vs = [15,25,35];
symbols = ["s","o","d"];
load("..\SteadyData.mat")
for i = 1:length(final_data)
    final_data(i).ang = atan2d(final_data(i).y,final_data(i).z);
    final_data(i).d = sqrt(final_data(i).z.^2 + final_data(i).y.^2);
    delta_side = 1067-abs(final_data(i).y);
    delta_top = 762-abs(final_data(i).z);
    delta_fillet = zeros(1,4);
    delta_fillet(1) = point_to_line([final_data(i).y,final_data(i).z,0],[1067,365,0],[435,762,0]);
    delta_fillet(2) = point_to_line([final_data(i).y,final_data(i).z,0],[-1067,-365,0],[-435,-762,0]);
    delta_fillet(3) = point_to_line([final_data(i).y,final_data(i).z,0],[-1067,365,0],[-435,762,0]);
    delta_fillet(4) = point_to_line([final_data(i).y,final_data(i).z,0],[1067,-365,0],[435,-762,0]);
    final_data(i).dist = min([delta_side,delta_top,delta_fillet]);
end
for i = 1:3
tmp_data = farg.struct.filter(final_data,{{'Job',jobs},{'ang',@(x)x<-104 & x>-114},{'U_inf',{'tol',Vs(i),1}}});
d = [tmp_data.dist];
V = [tmp_data.U];
idx = (d)<200;
V = V./max(V(idx))*100;
plot(V,d,symbols(i),Color=c(i,:),DisplayName=sprintf('%.0f m/s',Vs(i)),MarkerFaceColor=c(i,:),LineWidth=1.5)
end

ylim([0,200])
grid on
xlabel('Percentage of Freestream Velocity [\%]')
ylabel('Distance from tunnel wall [mm]')
lg = legend();
lg.Location = "northwest";
lg.Title.String = 'Tunnel Velocity';
lg.FontSize = 10;
title('Fillet D')

ax = gca;
ax.FontSize = 10;


function d = point_to_line(pt, v1, v2)
a = v1 - v2;
b = pt - v2;
d = norm(cross(a,b)) / norm(a);
end

