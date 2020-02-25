clc, clear all

% databases to compare
db1 = '../NuclearBurn/reference_lref3/cellular_hdf5_chk_';
db2 = '../NuclearBurn/multires_lref3_1e02_bn/cellular_hdf5_chk_';

% set variable of interest
var = 'enuc';

% loop through all checkpoint files
cnt = 0; search = true;
while(search)

  % current files 1 and 2
  cfile1 = sprintf('%s%0.4i',db1,cnt)
  cfile2 = sprintf('%s%0.4i',db2,cnt)

  % compute error between databases (get handles)
  H1 = hdf5info(cfile1);
  H2 = hdf5info(cfile2);

  % find desired dataset index
  for i = 1:length(H1.GroupHierarchy.Datasets)
    if strcmp(H1.GroupHierarchy.Datasets(i).Name, sprintf('/%s',var))
      ind = i;
    end
  end

  % read data
  data1 = hdf5read(H1.GroupHierarchy.Datasets(ind));

  % find desired dataset index
  for i = 1:length(H2.GroupHierarchy.Datasets)
    if strcmp(H2.GroupHierarchy.Datasets(i).Name, sprintf('/%s',var))
      ind = i;
    end
  end

  % read data
  data2 = hdf5read(H2.GroupHierarchy.Datasets(ind));

  % perform custom computation
  data3 = abs(data1-data2) / max(max(max(data1)));
  %data3 = abs(data1-data2);

  err(cnt+1) = max(max(max(data3)));

  % append resultant data to one of the hdf5 files
  h5write(cfile1,'/msk3',data3);

  % update counter
  cnt = cnt + 1

  % check if file dne
  if exist(sprintf('%s%0.4i',db1,cnt+1)) ...
    + exist(sprintf('%s%0.4i',db2,cnt+1)) == 0

    % stopping
    search = false;

  end


end
