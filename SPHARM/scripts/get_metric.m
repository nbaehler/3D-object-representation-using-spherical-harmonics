function metric = get_metric(fname,n);
% get metric from file metric
%

% read from metric file
disp(sprintf('read verts from %s ...',fname));
fid = fopen(fname,'r');
metric = fread(fid, n, 'double'); 
fclose(fid);

return;

