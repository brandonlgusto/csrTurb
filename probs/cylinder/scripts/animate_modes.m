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

% reconstruct DMD solution
modes = [1:20];

% plot options
fs = 15;

% play movie frames
figure(1)
vid = VideoWriter('cylinder_movie.mp4','MPEG-4');
vid.FrameRate = 14;
open(vid);
for i = 1:nt

    % first subplot
    subplot(4,1,1)

    % set the desired modes
    modes = 1:2;

    % compute approximate vorticity
    vort = 0.0;
    for k = 1:length(modes)
        p = modes(k);
        vort = vort + psi(:,p) * exp(frq(p)*t(i)) * amp(p);
    end
    vort_aprx = real(reshape(vort, [cyl.nx,cyl.ny]));

    % create figure
    contourf(X,Y,vort_aprx); hold on;
    set(gca,'DataAspectRatio', [1 2.2626 1]);
    ylabel('$\frac{y}{D}$','fontsize',fs,'interpreter','latex');
    caxis([-0.2 1.2])
    colorbar;

    % first subplot
    subplot(4,1,2)

    % set the desired modes
    modes = 1:3;

    % compute approximate vorticity
    vort = 0.0;
    for k = 1:length(modes)
        p = modes(k);
        vort = vort + psi(:,p) * exp(frq(p)*t(i)) * amp(p);
    end
    vort_aprx = real(reshape(vort, [cyl.nx,cyl.ny]));

    % create figure
    contourf(X,Y,vort_aprx); hold on;
    set(gca,'DataAspectRatio', [1 2.2626 1]);
    ylabel('$\frac{y}{D}$','fontsize',fs,'interpreter','latex');
    caxis([-0.2 1.2])
    colorbar;

    % first subplot
    subplot(4,1,3)

    % set the desired modes
    modes = 1:4;

    % compute approximate vorticity
    vort = 0.0;
    for k = 1:length(modes)
        p = modes(k);
        vort = vort + psi(:,p) * exp(frq(p)*t(i)) * amp(p);
    end
    vort_aprx = real(reshape(vort, [cyl.nx,cyl.ny]));

    % create figure
    contourf(X,Y,vort_aprx); hold on;
    set(gca,'DataAspectRatio', [1 2.2626 1]);
    ylabel('$\frac{y}{D}$','fontsize',fs,'interpreter','latex');
    caxis([-0.2 1.2])
    colorbar;

    % first subplot
    subplot(4,1,4)

    % set the desired modes
    modes = 1:6;

    % compute approximate vorticity
    vort = 0.0;
    for k = 1:length(modes)
        p = modes(k);
        vort = vort + psi(:,p) * exp(frq(p)*t(i)) * amp(p);
    end
    vort_aprx = real(reshape(vort, [cyl.nx,cyl.ny]));

    % create figure
    contourf(X,Y,vort_aprx); hold on;
    set(gca,'DataAspectRatio', [1 2.2626 1]);
    ylabel('$\frac{y}{D}$','fontsize',fs,'interpreter','latex');
    caxis([-0.2 1.2])
    colorbar;

    % place cylinder
    fill(x,y,[.3 .3 .3]);
    plot(x,y,'k','LineWidth',1.2); hold off;

    % plot settings
    colormap(parula);
    xlabel('$\frac{x}{D}$','fontsize',fs,'interpreter','latex');
    ylabel('$\frac{y}{D}$','fontsize',fs,'interpreter','latex');

    % pause
    pause(0.001);

    % save frames
    writeVideo(vid,getframe(gcf));

end

% close video object
close(vid);
