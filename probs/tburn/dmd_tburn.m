clc, clear all, clf

% add FlashX to path
addpath('../../scripts/FlashX');
addpath('../../src');

%------- gather data --------%

% number of files
nframes = 70;

% pre-specify nx and ny
nx = 1024;
ny = 1024;

% initialize data matrix
X = zeros(nx*ny,nframes);

% build data matrix
for i = 1:nframes
    [data x y] = GrabDataUniform2D(sprintf('data/tburn_hdf5_plt_cnt_%4.4i',i-1),'velx');
    X(:,i) = data(:);
end

%------- run the dmd -------%

% number of modes
nmodes = 4;

% run the dmd
[psi, lam, amp, frq] = dmd(X,nmodes);

%------- perform reconstruction -------%

% sample time domain
t = linspace(0,1e-05,nframes);

% plot options
fs = 15;

%% compute approximate vorticity
%vort = 0.0;
%for k = 1:nmodes
%    vort = vort + psi(:,k) * exp(frq(k)*t(nframes)) * amp(k);
%end
%vort_aprx = real(reshape(vort, [nx,ny]));

mode1 = real(reshape(psi(:,1), [nx,ny]));
mode2 = real(reshape(psi(:,2), [nx,ny]));
mode3 = real(reshape(psi(:,3), [nx,ny]));
mode4 = real(reshape(psi(:,4), [nx,ny]));

% create figure
%surf(vort_aprx); hold on;
%view(2);
%dummyh = line(nan, nan, 'Linestyle', 'none', 'Marker', 'none', 'Color', 'none');
%legend(dummyh,'1 mode','location','northwestoutside'); legend boxoff;
%colorbar;

figure(1)
colormap jet;
subplot(221)
h = surf(x,y,mode1); view(2);
colorbar;
set(h,'linestyle','none');
subplot(222)
h = surf(x,y,mode2); view(2);
set(h,'linestyle','none');
colorbar;
subplot(223)
h = surf(x,y,mode3); view(2);
set(h,'linestyle','none');
colorbar;
subplot(224)
h = surf(x,y,mode4); view(2);
set(h,'linestyle','none');
colorbar;
