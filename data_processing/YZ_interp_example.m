V_interp = 25;
[V,Pitch,Yaw] = YZ_interp(V_interp);
f = figure(1);
f.Units = "centimeters";
f.Position = [4,4,16,4.5];
clf;
tt = tiledlayout(1,3);
tt.Padding = "compact";
tt.TileSpacing = 'compact';


[Y,Z] = meshgrid(linspace(-2133.6/2,2133.6/2,101),linspace(-1524/2,1524/2,101));

nexttile(1)
val_interp = V(Y,Z)-V_interp;
[~,cf] = contourf(Y,Z,val_interp,60);
cf.LineStyle = 'none';
title('Velocity Delta [m/s]')
clim([0 2])

nexttile(2)
val_interp = Pitch(Y,Z);
[~,cf] = contourf(Y,Z,val_interp,60);
cf.LineStyle = 'none';
title('Pitch Angle [deg]')
nexttile(3)
val_interp = Yaw(Y,Z);
[~,cf] = contourf(Y,Z,val_interp,60);
cf.LineStyle = 'none';
title('Yaw Angle [deg]')