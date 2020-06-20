% This file displays a series of registered surfaces that have been
% compared to one another for differences.  The differences are identified
% in the vector vertexValues. 

clear;
disp(' ');
currentDir = '.';

% get the list of files to plot
[names, currentDir] = uigetfile({'*mod.mat','Matlab *mod.mat files'},'Select files to render',currentDir,'MultiSelect','on');
[fake, n] = size(names);
moreThanOneFile = iscell(names);
if (isnumeric(names))
    disp('No files chosen, so function MLMakeModels is returning.');
    currentDir = cd;
    return
else
    if moreThanOneFile
        for i=1:n
            disp(names{i});
        end
    else
        n = 1;
        disp(names);
    end
end

% From these files, find the minimum and maximum values for vertexValues
minVertex = 0;
maxVertex = 0;
for j = 1:n
    if (moreThanOneFile)
        file = fullfile(currentDir,names{i});
    else
        file = fullfile(currentDir,names);
    end
    file = deblank(file);
    [currentDir, name, ext] = fileparts(file);
disp([' processing ' name ext]);
    load(file);
    minVertex = min(vertexValues);
    maxVertex = max(vertexValues);
    
   
%     if ~exist('centroidSize','var')
%         centroidSize = -1;
%     end

end

% Make vector of minVertex value to revalue the vertexValues for each file.
minMatrix = zeros(size(vertexValues,1),1);
for j=1:size(vertexValues,1)
    minMatrix(j,1) = minVertex;
end

% Make subplot information with 4 columns
cols = 4;
if (n<=cols)
    rows = 1;
    cols = n;
else
    rows = floor(n/cols);
    if ((mod(n,(rows*cols))) > 0) 
        rows = rows + 1;
    end
end

figNum = 0;
colormap(jet);
figure;

for j=1:n
    hold on;
    figNum = figNum+1;
    subplot(rows,cols,figNum);
    if (moreThanOneFile)
        file = fullfile(currentDir,names{j});
    else
        file = fullfile(currentDir,names);
    end
    file = deblank(file);
    [currentDir, name, ext] = fileparts(file);
    load(file);
    % rescale vertexValues
    vertexValues = (vertexValues-minMatrix)/(maxVertex-minVertex);
    patch('faces', spharmFaces, 'vertices', spharmVertices, ...
		'FaceVertexCData', vertexValues, ...
		'EdgeColor', 'interp', 'FaceColor', 'interp', 'FaceAlpha', 1); % transparancy can be adjusted by FaceAlpha
    axis off;
    l1 = light('position', [-1 -1 .1], 'color', [.3 .3 .3]);
    l2 = light('position', [1 -1 .1], 'color', [.3 .3 .3]);
    l3 = light('position', [-.5 1 .1], 'color', [.3 .3 .3]);
    l4 = light;
    material dull;
    lighting phong;
    title(strrep(name(1:12),'_','-'));
    hold off;
%     clear('dg', 'faceValues', 'faces', 'fvec', 'landmarks', ...
%         'sph_verts', 'spharmFaces', 'spharmVertices', 'vertexValues', 'vertices');
end

disp('DisplayDifferenceSurfaces.m finished.')
