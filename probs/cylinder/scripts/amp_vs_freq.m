% load data
cyl = load('CYLINDER_ALL.mat');

% get results from dmd code
nmodes = 21;
[ vortPsi vortLam amp w] = dmd( cyl.UALL, nmodes );
w = imag(w);

%choose indices with positive frequencies
pos_modes = [];
for i = 1:nmodes
    if w(i) >= 0
        pos_modes = [pos_modes i];
    end
end

% plot of amplitudes vs. frequencies
figure(1);
fig = gcf;
set(fig, 'Name', 'Amplitude vs. Frequency');
plot(w(pos_modes), abs(amp(pos_modes)),'bo');
fs = 20;
xlabel('$w_k$','fontsize',fs,'interpreter','latex');
ylabel('$b_k$','fontsize',fs,'interpreter','latex');
axis([-10 max(w) -50 300]);
print( fig, 'amp_vs_freq', '-dpng', '-r500' );
