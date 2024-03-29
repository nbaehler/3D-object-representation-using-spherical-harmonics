% This program calculates the differences among a set of SPHARM models and
% produces surfaces for each which are colored based on the differences of
% the vertices of each from the average surface.
%
% All analyses are based on reconstructing surfaces from the fvec functions
% so that all models are reconstructed on the same set of vertices, and
% vertices are therefore comparable.
%
% First, the average surface is calculated and saved to disk.  Then each
% surface is compared to the average surface vertex by vertex.  The
% distance between the vertices on the two are calculated.  The vector from
% the vertex on the shape to the corresponding vertex on the average
% surface is calculated, and then the normal for a triangle containing this
% vertex is also calculated.  The angle between these two vectors is
% calculated and used to determine whether the surface vertex is on the
% outside or inside of the average surface.  If on the outside, the vertex
% value is positive.  If on the inside of the average surface, the vertex
% value is negative.  The vertexValues can then be used to color the
% surface to show where deviations exist.

% parameters set for running analyses
disp('INSIDE DifferencesAmongModels.');
clear;
meshsize = -5; % mesh format to use
outputFormat = 'Amira'; % output format for models written to disk
platonic = 'average'; % source of model for comparison 'average' or 'specify'
currentDir = '.';
%currentDir = 'C:\Users\Mark McPeek\Documents\Work\Damselflies\Morphology\Spherical Harmonic Analyses\Male Data\Enallagma Cerci Sexual Selection';

% variables needed
averageFvec = [];
averageFaces = [];
averageVertices = [];
faceValues = [];
vertexValues = [];
face = [];
fullCentroid = [];
numModelVertices = 0;
numModelFaces = 0;
minDistDiff = 0;
maxDistDiff = 0;

% get models for comparison from the disk
[names, currentDir] = uigetfile({'*.mat', 'Matlab .mat files'; ...
                            '*_reg.mat', 'Matlab registered _reg.mat files'; ...
                                '*.*', 'All files'}, ...
    'Select SPHARM registered model Files', currentDir, 'MultiSelect', 'on');
[fake, n] = size(names);
moreThanOneFile = iscell(names);

if (isnumeric(names))
    disp('No files chosen.');
    currentDir = cd;
    return
else

    if moreThanOneFile

        for i = 1:n
            disp(names{i});
        end

    else
        disp('More than one file must be selected.');
        currentDir = cd;
        return
    end

end

% if meshsize == 0 reconstruct original.  Otherwise, build model based on sampling resolution
% specified by input meshsize.
if (meshsize == 0)
    meshsize = []; suffix = '_orig'; meshsize{1} = sph_verts; meshsize{2} = faces;
end

if (meshsize > 0)
    suffix = ['_grid' int2str(meshsize)];
end

if (meshsize < 0)
    suffix = ['_ico' int2str((-1 * meshsize))];
end

% First make models for each surface, save the model with the rest of the
% data in a new file and accumulate the locations of the vertices in a
% matrix to calculate the average surface.
for i = 1:n
    file = fullfile(currentDir, names{i});
    file = deblank(file);
    [currentDir, name, ext] = fileparts(file);
    load(file);

    % make surface based on mesh picked
    [spharmVertices, spharmFaces] = surf_spharm(fvec, dg, meshsize);

    if (i == 1)
        averageFvec = fvec;
        averageVertices = spharmVertices;
        %        averageFaces = spharmFaces;
        averageLandmarks = landmarks;
        [numModelVertices, fake] = size(spharmVertices);
        [numModelFaces, fake] = size(spharmFaces);
    else
        averageFvec = averageFvec + fvec;
        averageVertices = averageVertices + spharmVertices;
        averageLandmarks = averageLandmarks + landmarks;
    end

end

averageFvec = (1 / n) * averageFvec;
averageVertices = (1 / n) * averageVertices;
averageLandmarks = (1 / n) * averageLandmarks;
% calculate centroid
centroid = mean(averageVertices);
% save average surface as a MAT file.
averageFileName = 'AverageSurface.mat';
outFile = fullfile(currentDir, averageFileName);
fvec = averageFvec;
vertices = averageVertices;
landmarks = averageLandmarks;

faces = averageFaces;
save(outFile, 'fvec', 'vertices', 'faces', 'landmarks', 'centroid', 'dg');

% Save average surface to file for visualization
switch outputFormat % format to use for output
    case 'Amira'
        outputToAmira(currentDir, 'AverageSurface', vertices, spharmFaces);
    case 'STL'
        outputToSTL(currentDir, 'AverageSurface', vertices, spharmFaces, landmarks);
    otherwise % Amira output is default
        outputToAmira(currentDir, 'AverageSurface', vertices, spharmFaces);
end

%calculate distance of each averageVertices to centroid
fullCentroid = zeros(numModelVertices, 3);

for i = 1:numModelVertices
    fullCentroid(i, :) = centroid;
end

averageModelDistToCentroid = averageVertices - fullCentroid;
averageModelDistToCentroid = averageModelDistToCentroid .* averageModelDistToCentroid;
averageModelDistToCentroid = sqrt(sum(averageModelDistToCentroid, 2));

% First find the maximum difference between the average surface
% and the models.  This will be used to rescale each of the vertex values
% to have the same scale across models.
for i = 1:n
    file = fullfile(currentDir, names{i});
    file = deblank(file);
    [currentDir, name, ext] = fileparts(file);
    load(file);
    % make surface based on mesh picked
    [spharmVertices, spharmFaces] = surf_spharm(fvec, dg, meshsize);

    % calculate distances between model and average vertices for each vertex
    vertexValues = spharmVertices - averageVertices;
    vertexValues = vertexValues .* vertexValues;
    vertexValues = sqrt(sum(vertexValues, 2));

    maximum = max(vertexValues);

    if i == 1
        maxDist = maximum;
    elseif (maximum > maxDist)
        maxDist = maximum;
    end

end

% Calculate the difference between the vertices of each model from the
% average model.  Then calculate the average difference for each model
% face, and save this difference in a vector to use for graphing.
% Also, add a vector of the maximum and minimum difference in each file,
% to set the limits of the graphic range to use.
for i = 1:n
    file = fullfile(currentDir, names{i});
    file = deblank(file);
    [currentDir, name, ext] = fileparts(file);
    load(file);
    % make surface based on mesh picked
    [spharmVertices, spharmFaces] = surf_spharm(fvec, dg, meshsize);

    % calculate distances between model and average vertices for each vertex
    vertexValues = spharmVertices - averageVertices;
    vertexValues = vertexValues .* vertexValues;
    vertexValues = sqrt(sum(vertexValues, 2));

    % Calculate normal for a triangle with each vertex, then see if vector
    % from average vertex to specific vertex is in same direction as normal
    % for that triangle.  If they are the same direction, then the vertex
    % on the specific shape is on the outside of the average shape, and if
    % they are in different directions, then the vertex on the specific
    % shape is on the inside of the average shape.  If the vertex on the
    % specific shape is on the outside of the average shape, make its value
    % positive, and if on the inside, make its value negative.

    % make vector from averageVertex to shapeVertex
    testVectors = averageVertices - spharmVertices;

    for j = 1:numModelVertices
        % find a triangle with this vertex
        for k = 1:numModelFaces

            if ((spharmFaces(k, 1) == j) || (spharmFaces(k, 2) == j) || (spharmFaces(k, 3) == j))
                break;
            end

        end

        % calculate normal vector of this found triangle k
        aVec = spharmVertices(spharmFaces(k, 2), :) - spharmVertices(spharmFaces(k, 1), :);
        bVec = spharmVertices(spharmFaces(k, 3), :) - spharmVertices(spharmFaces(k, 1), :);
        normalVec(1, 1) = aVec(1, 2) * bVec(1, 3) - aVec(1, 3) * bVec(1, 2);
        normalVec(1, 2) = aVec(1, 3) * bVec(1, 1) - aVec(1, 1) * bVec(1, 3);
        normalVec(1, 3) = aVec(1, 1) * bVec(1, 2) - aVec(1, 2) * bVec(1, 1);
        % calculate lengths of vectors
        lengthTestVector = sqrt(testVectors(j, :) * testVectors(j, :)');
        lengthNormal = sqrt(normalVec * normalVec');
        % calculate angle between testVectors(j,:) and normalVec
        theta = acos((testVectors(j, :) * normalVec') / (lengthTestVector * lengthNormal));
        % assign sign of vertexValues based on this angle.  Make it
        % negative it the angle is obtuse, and leave sign positive if it's
        % acute
        if ((theta > (pi / 2)) && (theta < (3 * pi / 2)))
            vertexValues(j, 1) = -1.0 * vertexValues(j, 1);
        end

    end

    % rescale these values to be between 0 and 255 for colormapping.
    maxMat = ones(size(vertexValues)) * maxDist;
    newVertexValues = 255 * ((vertexValues + maxMat) ./ (2.0 * maxDist));
    vertexValues = newVertexValues;

    % Make faceValues for faces of this model as the average of the three
    % vertex values for that triangle
    faceValues = zeros(numModelFaces, 1);

    for j = 1:numModelFaces
        face = spharmFaces(j, :);
        faceValues(j, 1) = (vertexValues(face(1, 1)) + vertexValues(face(1, 2)) + vertexValues(face(1, 3))) / 3;
    end

    % save this new model to a file
    if ~exist('centroidSize', 'var')
        centroidSize = -1;
    end

    new_name = names{i};
    new_name = new_name(1:end - 4);
    %     mat_name = sprintf('%smod.mat',new_name);
    %     save(fullfile(currentDir,mat_name), ...
    %         'fvec', 'vertices', 'faces', 'dg', 'meshsize', 'spharmVertices', 'spharmFaces', ...
    %         'vertexValues', 'faceValues');

    % output surface in Amira format
    surfName = sprintf('%smod', new_name);
    outputToAmira(currentDir, surfName, spharmVertices, spharmFaces);

    % Write vertexValues and faceValues to files in Amira format.
    vertFileName = sprintf('%smodSurfaceFieldVerts.am', new_name);
    faceFileName = sprintf('%smodSurfaceFieldFaces.am', new_name);
    % vertex file
    fileString = fullfile(currentDir, vertFileName);
    fid = fopen(fileString, 'w');
    fprintf(fid, '# AmiraMesh 3D ASCII 2.0\n\n');
    fprintf(fid, '\n');
    fprintf(fid, 'nNodes %i\n\n', numModelVertices);
    fprintf(fid, 'Parameters {\n');
    fprintf(fid, '    ContentType "SurfaceField",\n');
    fprintf(fid, '    Encoding "OnNodes"\n');
    fprintf(fid, '}\n\n');
    fprintf(fid, 'NodeData { float values } @1\n');
    fprintf(fid, '\n');
    fprintf(fid, '# Data section follows\n');
    fprintf(fid, '@1\n');

    for i = 1:numModelVertices
        fprintf(fid, '%8.3f\n', vertexValues(i, 1));
    end

    fprintf(fid, '\n');
    fclose(fid);
    % faces file
    fileString = fullfile(currentDir, faceFileName);
    fid = fopen(fileString, 'w');
    fprintf(fid, '# AmiraMesh 3D ASCII 2.0\n\n');
    fprintf(fid, '\n');
    fprintf(fid, 'nTriangles %i\n\n', numModelFaces);
    fprintf(fid, 'Parameters {\n');
    fprintf(fid, '    ContentType "SurfaceField",\n');
    fprintf(fid, '    Encoding "OnTriangles"\n');
    fprintf(fid, '}\n\n');
    fprintf(fid, 'TriangleData { float values } @1\n');
    fprintf(fid, '\n');
    fprintf(fid, '# Data section follows\n');
    fprintf(fid, '@1\n');

    for i = 1:numModelFaces
        fprintf(fid, '%8.3f\n', faceValues(i, 1));
    end

    fprintf(fid, '\n');
    fclose(fid);
end

% make the same files for the average surface file.
% maxMat = ones(size(vertexValues))*maxDist;
% newVertexValues = 255*((zeros(size(vertexValues)) + maxMat)./(2.0*maxDist));
% vertexValues = newVertexValues;

aveValue = 255 * (maxDist / (2.0 * maxDist));

% Write vertexValues and faceValues to files in Amira format.
vertFileName = 'AverageSurfacemodSurfaceFieldVerts.am';
faceFileName = 'AverageSurfacemodSurfaceFieldFaces.am';
% vertex file
fileString = fullfile(currentDir, vertFileName);
fid = fopen(fileString, 'w');
fprintf(fid, '# AmiraMesh 3D ASCII 2.0\n\n');
fprintf(fid, '\n');
fprintf(fid, 'nNodes %i\n\n', numModelVertices);
fprintf(fid, 'Parameters {\n');
fprintf(fid, '    ContentType "SurfaceField",\n');
fprintf(fid, '    Encoding "OnNodes"\n');
fprintf(fid, '}\n\n');
fprintf(fid, 'NodeData { float values } @1\n');
fprintf(fid, '\n');
fprintf(fid, '# Data section follows\n');
fprintf(fid, '@1\n');

for i = 1:numModelVertices
    fprintf(fid, '%8.3f\n', aveValue);
end

fprintf(fid, '\n');
fclose(fid);
% faces file
fileString = fullfile(currentDir, faceFileName);
fid = fopen(fileString, 'w');
fprintf(fid, '# AmiraMesh 3D ASCII 2.0\n\n');
fprintf(fid, '\n');
fprintf(fid, 'nTriangles %i\n\n', numModelFaces);
fprintf(fid, 'Parameters {\n');
fprintf(fid, '    ContentType "SurfaceField",\n');
fprintf(fid, '    Encoding "OnTriangles"\n');
fprintf(fid, '}\n\n');
fprintf(fid, 'TriangleData { float values } @1\n');
fprintf(fid, '\n');
fprintf(fid, '# Data section follows\n');
fprintf(fid, '@1\n');

for i = 1:numModelFaces
    fprintf(fid, '%8.3f\n', aveValue);
end

fprintf(fid, '\n');
fclose(fid);

disp('DifferencesAmongModels finished.');
