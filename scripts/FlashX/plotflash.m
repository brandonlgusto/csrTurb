function [] = plotflash(path,basenm,var,frames,platt,iprint)

%-------------------------------------------------------------------------------%
% Info:
%   This function reads data from FLASH hdf5 files and plots desired
%   quantities.
%
% Inputs:
%   path -    the path to the data
%   basenm -  the basename of the hdf5 checkpoint files
%   var -     the variable to be plotted from hdf5 files
%   frames -  the array of desired checkpoint files to include in the movie or
%             plot
%   platt.ordnm -   name of the ordinate axis
%   ptitle -  plot title
%   iprint -  logical which decides whether or not to save a movie or image
%-------------------------------------------------------------------------------%

  % loop through desired frames
  for i = 1:length(frames)

    % set current frame
    iframe = frames(i);

    % get hdf5 data for current frame
    Data = grabhdf5(sprintf('%s%s_hdf5_chk_%0.4i',path,basenm,iframe),...
                    {'refine level', 'bounding box','node type',var});

    % organize block data
    amrlvls = Data{1};
    nblocks = length( Data{2}(1,1,:) );
    nodetyp = Data{3};
    ncells = length( Data{4}(:,1,1,1) );

    % initialize vectors
    mylvl = [];
    cellw = [];
    coordx = [];
    vardata = [];

    % loop through blocks
    for blk = 1 : nblocks

      if nodetyp(blk) == 1

        % ends of block
        xlo = Data{2}(1,1,blk);
        xhi = Data{2}(2,1,blk);

        % cell width
        dx(blk) = ( xhi - xlo ) / ncells;

        % concatenate cell data
        mylvl = [ mylvl double(amrlvls(blk)) * ones(1,ncells) ];
        cellw = [ cellw dx(blk) * ones(1,ncells) ];
        coordx = [ coordx xlo+dx(blk)/2:dx(blk):xhi-dx(blk)/2 ];
        vardata = [ vardata Data{4}(:,1,1,blk)' ];

      end

    end

    % sort data based on coordinates
    [coordx ia] = sort(coordx);
    mylvl = mylvl(ia);
    cellw = cellw(ia);
    vardata = vardata(ia);

    % figure parameters
    mi = 15; % marker index
    bt = 1.5; % border thickness

    % plot 1
    figure(1)
    plot(coordx, vardata, 'k', 'linewidth', 2.0); hold on;
    ylabel(platt.ordnm,'fontsize',16,'interpreter','latex');
    title(platt.ptitle,'interpreter','latex');
    set(gca,'linewidth',bt)

    % disable top and right tick marks
    a = gca;
    set(a,'box','off','color','none')
    b = axes('Position',get(a,'Position'),'box','on','xtick',[],'ytick',[],'linewidth',bt); axes(a)
    linkaxes([a b])

    % save frame
    if length(frames) > 1
      F(i) = getframe(gcf);
      drawnow
    end

  end

  % movie or still?
  if length(frames) > 1

    % save movie
    writerObj = VideoWriter(sprintf('%s.avi',platt.ptitle));
    writerObj.FrameRate = 15;
    writerObj.Quality = 100;
    open(writerObj);
    for i=1:length(F)
      writeVideo(writerObj, F(i));
    end
    close(writerObj);

  else

    % save still
    print(figure(1),platt.ptitle,'-dpng');

  end

end
