clc, clear all, clf

% load data from hdf5 file
[data x y] = GrabDataUniform2D('../NuclearBurn/data/ref_2d_uni3/cellular_hdf5_chk_0049','dens');

% make a surface plot + change view to 2D
surf(x,y,data,'EdgeColor','None');
view(2);

% set axis ranges
xmin = 0.0;
xmax = 150;
ymin = 0.0;
ymax = 12.8;

% edit plot attributes
axis([xmin xmax ymin ymax]);
pbaspect([xmax/ymax 1 1]);
colormap jet;
colorbar;

% modify size of image
fig = gcf;
fig.PaperPositionMode = 'auto'
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];

% print figure
%print(fig,'cellular','-dpng','-r500');
