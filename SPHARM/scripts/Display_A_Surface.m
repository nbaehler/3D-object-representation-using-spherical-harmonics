% This file displays a series of registered surfaces

clear;
disp(' ');

% Identify directory containing files to process and then input files
[inFile, inDir, n] = uigetfile('*.*', 'Open Surface File');

fileString = fullfile(inDir, inFile);
fileString = deblank(fileString); 

load(fileString);
display_surface(inFile, vertices, faces);

disp('Display_A_Surface.m finished.')
