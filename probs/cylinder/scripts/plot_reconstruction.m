clc, clear all, clf

% number of modes
nmodes = 40;

% load data
cyl = load('CYLINDER_ALL.mat');

% number of timesteps
nt = length(cyl.UALL(1,:));

% sample time domain
t = linspace(0,9,nt);

% non-dimensional x- and y-coordinates for flow data
x = (0:cyl.ny-1) / 50;
y = (0:cyl.nx-1) / 50;
[X,Y] = meshgrid(x,y);

% for plotting cylinder
theta = (1:100)/100'*2*pi;
x = 1+0.5*sin(theta);
y = 2+0.5*cos(theta);

% get results from dmd code
[psi, lam, amp, frq] = dmd(cyl.UALL, nmodes);

% plot options
fs = 15;

% play movie frames
figure(1)

% first subplot
subplot(4,1,1)

% set the desired modes
modes = [1];

% compute approximate vorticity
vort = 0.0;
for k = 1:length(modes)
    p = modes(k);
    vort = vort + psi(:,p) * exp(frq(p)*t(nt)) * amp(p);
end
vort_aprx = real(reshape(vort, [cyl.nx,cyl.ny]));

% create figure
contourf(X,Y,vort_aprx); hold on;
dummyh = line(nan, nan, 'Linestyle', 'none', 'Marker', 'none', 'Color', 'none');
legend(dummyh,'1 mode','location','northwestoutside'); legend boxoff;
set(gca,'DataAspectRatio', [1 2.2626 1]);
ylabel('$\frac{y}{D}$','fontsize',fs,'interpreter','latex');
caxis([-0.2 1.2])
colorbar;

% place cylinder
h = fill(x,y,[.3 .3 .3]);
h.Annotation.LegendInformation.IconDisplayStyle = 'off';
h = plot(x,y,'k','LineWidth',1.2); hold off;
h.Annotation.LegendInformation.IconDisplayStyle = 'off';

% first subplot
subplot(4,1,2)

% set the desired modes
modes = 1:2;

% compute approximate vorticity
vort = 0.0;
for k = 1:length(modes)
    p = modes(k);
    vort = vort + psi(:,p) * exp(frq(p)*t(nt)) * amp(p);
end
vort_aprx = real(reshape(vort, [cyl.nx,cyl.ny]));

% create figure
contourf(X,Y,vort_aprx); hold on;
dummyh = line(nan, nan, 'Linestyle', 'none', 'Marker', 'none', 'Color', 'none');
legend(dummyh,'2 modes','location','northwestoutside'); legend boxoff;
set(gca,'DataAspectRatio', [1 2.2626 1]);
ylabel('$\frac{y}{D}$','fontsize',fs,'interpreter','latex');
caxis([-0.2 1.2])
colorbar;

% place cylinder
h = fill(x,y,[.3 .3 .3]);
h.Annotation.LegendInformation.IconDisplayStyle = 'off';
h = plot(x,y,'k','LineWidth',1.2); hold off;
h.Annotation.LegendInformation.IconDisplayStyle = 'off';

% first subplot
subplot(4,1,3)

% set the desired modes
modes = 1:3;

% compute approximate vorticity
vort = 0.0;
for k = 1:length(modes)
    p = modes(k);
    vort = vort + psi(:,p) * exp(frq(p)*t(nt)) * amp(p);
end
vort_aprx = real(reshape(vort, [cyl.nx,cyl.ny]));

% create figure
contourf(X,Y,vort_aprx); hold on;
dummyh = line(nan, nan, 'Linestyle', 'none', 'Marker', 'none', 'Color', 'none');
legend(dummyh,'3 modes','location','northwestoutside'); legend boxoff;
set(gca,'DataAspectRatio', [1 2.2626 1]);
ylabel('$\frac{y}{D}$','fontsize',fs,'interpreter','latex');
caxis([-0.2 1.2])
colorbar;

% place cylinder
h = fill(x,y,[.3 .3 .3]);
h.Annotation.LegendInformation.IconDisplayStyle = 'off';
h = plot(x,y,'k','LineWidth',1.2); hold off;
h.Annotation.LegendInformation.IconDisplayStyle = 'off';

% first subplot
subplot(4,1,4)

% plot the true velocity
vort_aprx = reshape(cyl.UALL(:,nt), [cyl.nx,cyl.ny]);

% use this if want another approximation
%%%% set the desired modes
%%%modes = 1:10;
%%%
%%%% compute approximate vorticity
%%%vort = 0.0;
%%%for k = 1:length(modes)
%%%    p = modes(k);
%%%    vort = vort + psi(:,p) * exp(frq(p)*t(nt)) * amp(p);
%%%end
%%%vort_aprx = real(reshape(vort, [cyl.nx,cyl.ny]));

% create figure
contourf(X,Y,vort_aprx); hold on;
dummyh = line(nan, nan, 'Linestyle', 'none', 'Marker', 'none', 'Color', 'none');
legend(dummyh,'True data','location','northwestoutside'); legend boxoff;
set(gca,'DataAspectRatio', [1 2.2626 1]);
ylabel('$\frac{y}{D}$','fontsize',fs,'interpreter','latex');
caxis([-0.2 1.2])
colorbar;

% place cylinder
h = fill(x,y,[.3 .3 .3]);
h.Annotation.LegendInformation.IconDisplayStyle = 'off';
h = plot(x,y,'k','LineWidth',1.2); hold off;
h.Annotation.LegendInformation.IconDisplayStyle = 'off';

% plot settings
colormap(parula);
xlabel('$\frac{x}{D}$','fontsize',fs,'interpreter','latex');
ylabel('$\frac{y}{D}$','fontsize',fs,'interpreter','latex');

print(figure(1), 'reconstruction', '-dpng', '-r500' );
