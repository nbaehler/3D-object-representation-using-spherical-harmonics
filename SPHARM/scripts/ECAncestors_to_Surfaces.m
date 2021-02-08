% This script reads in .mat files of multiple fvecs converted from  the
% Contrasts program to make surfaces for the ancestors that are output.

clear;
disp(' ');


% Build format statement to read in a text file wiht as many columns as
% there are in the input file.  The input file will have the names of the
% taxa in the first column, and then the fvec coefficients in the remaining
% columns.

ncols = 769;
numCoeffs = ncols-1;

format = [];
for k = 1 :ncols
	format = strcat(format, '%s');
end
	
% Identify file with fvecs to process
[filename, path] = uigetfile({'*.eca'; '*.phe'; '*.*'}, 'pick file with Fvec ancestors');

fid = fopen(fullfile(path, filename),'r'); % open file
C = textscan(fid,format); % import data

names = C(:,1);
C = C(:,2:end);

% Output Directory
outDir =uigetdir(path,'Directory for output of Ancestors');


for k = 1:numCoeffs
	col_char(k).col = char(C{k});
end

for k = 1:numCoeffs
	for j = 1:size(col_char(k).col,1)
		data(j,k) = eval(col_char(k).col(j,:)); % string to complex number
	end
end

[ntaxa numCoeffs] = size(data);

fclose(fid);

degrees = zeros(1,2);
degrees(2) = sqrt(numCoeffs/3) - 1;
degrees(1) = 0;

% meshsize determines the size of the grid of triangles placed on the
%	surface when the model surface is backcalculated from the spherical
%	harmonic model
% Positive values
% meshsize = k for k>0: reconstruction mesh will be a k*k grid
% meshsize = 32:  reconstruction mesh will be a 32*32 grid
% Negative values
% meshsize = -1: mesh will be icosahedron subdivision level 1
% meshsize = -2: mesh will be icosahedron subdivision level 2
% meshsize = -k for k>0: mesh will be icosahedron subdivision level k
% Underlying spherical mesh is an icosahedron subdivision at level 5
meshsize = -5; 

suffix = '_ico5';

% do processing of each file
for k = 1:ntaxa;
	fvec = data(k,:);
	fvec = reshape(fvec,3,(numCoeffs/3));
	fvec = fvec.';
	% make surface based on mesh picked
	[spharm_vertices, spharm_faces] = surf_spharm(fvec,degrees,meshsize);
	outputToAmira(outDir, [names{1}{k} suffix], spharm_vertices, spharm_faces);
%	outputToSTL(outDir, [names{1}{k} suffix], spharm_vertices, spharm_faces);
	clear spharm_vertices spharm_faces;

end

disp('ECAncestors_To_Surfaces finished.');



