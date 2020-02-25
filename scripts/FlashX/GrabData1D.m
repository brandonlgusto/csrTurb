function [vdata x] = GrabData1D(filenm, varnm)

%-------------------------------------------------------------------------------%
% Info:
%   This function grabs data from FLASH hdf5 files for the variable of interest.
%   The function essentially takes block-partitioned data and converts it into
%   a single array. Assumes data is cell-centered.
%
% Inputs:
%   filenm -  the hdf5 filename
%   varnm -   the variable name to be plotted from hdf5 files (a string)
%
% Outputs:
%   vdata - the output array
%
%-------------------------------------------------------------------------------%

  % get 'varnm' variable data from current hdf5 data
  Data = GrabHDF5(filenm,{'node type', 'bounding box', varnm});

  % amr metadata 
  nodetyp = Data{1};
  nblocks = length(Data{1});
  nxb = length(Data{3}(:,1,1,1));

  % initialize vectors
  x = [];
  vdata = [];

  % loop through blocks
  for blk = 1 : nblocks

    if nodetyp(blk) == 1

      % ends of block (1=lo,2=hi)
      xlo = Data{2}(1,1,blk);
      xhi = Data{2}(2,1,blk);

      % cell width
      dx = ( xhi - xlo ) / nxb;

      % concatenate cell data
      x = [ x xlo+dx/2:dx:xhi-dx/2 ];
      vdata = [ vdata Data{3}(:,1,1,blk)' ];

    end

  end

  % sort data based on coordinates
  [x ia] = sort(x);
  vdata = vdata(ia);

end
