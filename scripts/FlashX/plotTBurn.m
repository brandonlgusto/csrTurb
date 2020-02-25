clc, clear all, clf

% load data from hdf5 file
[data x y] = GrabDataUniform2D('tburn_hdf5_chk_0001','pres');

% make a surface plot + change view to 2D
surf(x,y,data,'EdgeColor','None');
view(2);

% set axis ranges
xmin = 0.0;
xmax = 3.2e06
ymin = 0.0;
ymax = 3.2e06

% edit plot attributes
axis([xmin xmax ymin ymax]);
%pbaspect([xmax/ymax 1 1]);
colormap jet;
colorbar;

% print figure
%print(fig,'cellular','-dpng','-r500');
