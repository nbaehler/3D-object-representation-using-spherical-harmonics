% This file displays a series of registered surfaces

clear;
disp(' ');

% Identify directory containing files to process and then input files
inDir = uigetdir;
files = dir(fullfile(inDir,'*_reg.mat'));
n = size(files,1);

names = cell(n,1);

% create cell IDs
for i = 1:n;
%	disp(files(i).name);
	names{i} = files(i).name(1:end-28);
end;

meshsize = -4;

for i=1:n
	fileString = fullfile(inDir, files(i).name);
	fileString = deblank(fileString); 

	load(fileString);
	display_surface(names{i}, vertices, faces);
%	disp_spharm_desc(fvec,meshsize,dg,path,names{i},[],0);
end

disp('Display_Registered_Surfaces.m finished.')
