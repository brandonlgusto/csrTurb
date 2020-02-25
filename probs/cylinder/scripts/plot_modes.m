% number of modes
nmodes = 21;

% load data
cyl = load('CYLINDER_ALL.mat');

% non-dimensional x- and y-coordinates for flow data
x = (0:cyl.ny-1) / 50;
y = (0:cyl.nx-1) / 50;
[X,Y] = meshgrid(x,y);

% get results from dmd code
[psi, lam, amp, frq] = dmd(cyl.UALL, nmodes);
psi_real = real( psi );
psi_imag = imag( psi );
lam_real = real( lam );
lam_imag = imag( lam );

% limit the range of values and noise
vortmin = -5;  % only plot what is in -5 to 5 range
vortmax = 5;
psi_real(psi_real>vortmax) = vortmax;  % cutoff at vortmax
psi_real(psi_real<vortmin) = vortmin;  % cutoff at vortmin
psi_imag(psi_imag>vortmax) = vortmax;  % cutoff at vortmax
psi_imag(psi_imag<vortmin) = vortmin;  % cutoff at vortmin

% noise reduction
psi_real( find(abs(psi_real)<1e-9) ) = 0.0;
psi_imag( find(abs(psi_imag)<1e-9) ) = 0.0;

% first plot real part of mode
for i = 1:nmodes

    % display eigenvalues
    disp( sprintf('Mode %i: lam_real = %f, lam_imag = %f',i,lam_real(i),lam_imag(i) ) );

    % plot of real mode
    figure(1)
    colormap(jet);
    contourf(X,Y,reshape(psi_real(:,i),[cyl.nx,cyl.ny]),'linewidth',1.2);

    % place cylinder
    hold on;
    theta = (1:100)/100'*2*pi;
    x = 1+0.5*sin(theta);
    y = 2+0.5*cos(theta);
    fill(x,y,[.3 .3 .3]);
    plot(x,y,'k','LineWidth',1.2);
    hold off;

    % plot settings
    fs = 20;
    colorbar;
    xlabel('$\frac{x}{D}$','fontsize',fs,'interpreter','latex');
    ylabel('$\frac{y}{D}$','fontsize',fs,'interpreter','latex');
    set(gca,'linewidth',2);
    set(gcf,'position',[0,0,900,400]);
    %a = gca;
    %set(a,'box','off','color','none');
    %b = axes('Position',get(a,'Position'),'box','on','xtick',[],'ytick',[],'linewidth',2);
    %axes(a)
    %linkaxes([a b])

    % save plot
    print( figure(1), sprintf('real_mode_%2.2i',i), '-dpng', '-r300' );

   %% plot of imaginary mode
   %figure(2)
   %colormap(jet);
   %contourf(X,Y,reshape(psi_imag(:,i),[cyl.nx,cyl.ny]),'linewidth',1.2);

   %% place cylinder
   %hold on;
   %theta = (1:100)/100'*2*pi;
   %x = 1+0.5*sin(theta);
   %y = 2+0.5*cos(theta);
   %fill(x,y,[.3 .3 .3]);
   %plot(x,y,'k','LineWidth',1.2);
   %hold off;

   %% plot settings
   %colorbar;
   %xlabel('$\frac{x}{D}$','fontsize',fs,'interpreter','latex');
   %ylabel('$\frac{y}{D}$','fontsize',fs,'interpreter','latex');
   %set(gca,'linewidth',2);
   %set(gcf,'position',[0,0,900,400]);
   %%a = gca;
   %%set(a,'box','off','color','none')
   %%b = axes('Position',get(a,'Position'),'box','on','xtick',[],'ytick',[],'linewidth',2);
   %%axes(a)
   %%linkaxes([a b])

   %% save plot
   %print( figure(2), sprintf('imag_mode_%2.2i',i), '-dpng', '-r300' );

end
