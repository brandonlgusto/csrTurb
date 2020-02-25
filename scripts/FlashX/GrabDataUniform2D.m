function [vdata X Y] = GrabDataUniform2D(filenm, varnm)

%-------------------------------------------------------------------------------%
% Info: This function grabs data from FLASH hdf5 files for the variable of
%   interest.  The function returns a an array the size of the numbre of blocks,
%   with each element containing that block's structured data (specified by
%   'varnm'). Assumes data is cell-centered (no face-vars).
%
% Inputs:
%   filenm -  the hdf5 filename
%   varnm -   the variable name to be plotted from hdf5 files (a string)
%
% Outputs:
%   vdata - the output data matrix
%
%-------------------------------------------------------------------------------%

  % get 'varnm' variable data from current hdf5 data
  Data = GrabHDF5(filenm,{'node type', 'bounding box', varnm});

  % amr metadata 
  nodetyp = Data{1};
  nblocks = length(Data{1});
  nxb = length(Data{3}(:,1,1,1));
  nyb = length(Data{3}(1,:,1,1));

  % initialize xmin, xmax, ymin, ymax + dxmin + dymin
  xmin = 0.0; xmax = 0.0;
  ymin = 0.0; ymax = 0.0;

  % initial sweep through data to get xmin, xmax, ymin, ymax + dx, dy
  for blk = 1:nblocks

    % check if leaf block
    if nodetyp(blk) == 1

      % ends of block (1=lo,2=hi)
      xlo = Data{2}(1,1,blk);
      xhi = Data{2}(2,1,blk);
      ylo = Data{2}(1,2,blk);
      yhi = Data{2}(2,2,blk); 

      % determine the bounding box of the global block
      xmin = min(xmin,xlo);
      xmax = max(xmax,xhi);
      ymin = min(ymin,ylo);
      ymax = max(ymax,yhi);

      % cell width
      dx = (xhi - xlo) / nxb;
      dy = (yhi - ylo) / nyb;

    end

  end

  % create the global domain
  x = xmin:dx:xmax;
  y = ymin:dy:ymax;

  % number of cells
  nx = length(x)-1;
  ny = length(y)-1;

  % create meshgrid
  [X, Y] = meshgrid(linspace(xmin,xmax,nx),linspace(ymin,ymax,ny));

  % initialize the global block
  vdata = zeros(ny,nx);

  % now map the data on blocks to the global data array
  for blk = 1:nblocks

    % check if leaf block
    if nodetyp(blk) == 1

      % ends of block (1=lo,2=hi)
      xlo = Data{2}(1,1,blk);
      xhi = Data{2}(2,1,blk);
      ylo = Data{2}(1,2,blk);
      yhi = Data{2}(2,2,blk); 

      % determine the starting (i,j) indices in global array
      iglb = int32((xlo - xmin) / dx + 1);
      jglb = int32((ylo - ymin) / dy + 1);

      % copy data
      for i = 0:nxb-1
        %disp(sprintf('i = %d', iglb+i))
        for j = 0:nyb-1
          %disp(sprintf('j = %d', jglb+j))
          vdata(jglb+j,iglb+i) = Data{3}(i+1,j+1,1,blk);
        end
      end

    end

  end

end
