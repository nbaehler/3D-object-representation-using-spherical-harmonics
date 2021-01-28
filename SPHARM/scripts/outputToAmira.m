function outputToAmira(fdir, fname, vertices, faces, varargin)
% This function outputs a surface triangular mesh in a format that is
% readable by Amira software.
% 
% The only varargin accepted in this file is the set of landmarks to be
% written to the file.  They are output in Amira format.

%disp('inside outputToAmira');
fileString = fullfile(fdir, strcat(fname, '.surf'));

disp(fname);
[nverts, a] = size(vertices);
[nfaces, a] = size(faces);

% output surface to Amira formatted file.
fid = fopen(fileString,'w');
fprintf(fid,'# HyperSurface 0.1 ASCII\n\n');
fprintf(fid,'\n');
fprintf(fid,'Parameters {\n');
fprintf(fid,'    Materials {\n');
fprintf(fid,'        Exterior {\n');
fprintf(fid,'            Id 1\n');
fprintf(fid,'        }\n');
fprintf(fid,'        Inside {\n');
fprintf(fid,'            Color 0.64 0 0.8,\n');
fprintf(fid,'            Id 2\n');
fprintf(fid,'        }\n');
fprintf(fid,'        Right_Cercus {\n');
fprintf(fid,'            Color 0.8 0.4 0.16,\n');
fprintf(fid,'            Id 3\n');
fprintf(fid,'        }\n');
fprintf(fid,'    }\n');
fprintf(fid,'    BoundaryIds {\n');
fprintf(fid,'        Name "BoundaryConditions"\n');
fprintf(fid,'    }\n');
fprintf(fid,'    GridBox -2.53 1568.6 -2.53 1507.88 -2.53 794.42,\n');
fprintf(fid,'    GridSize 622 598 316,\n');
fprintf(fid,'    Filename "outputsurface.surf"\n');
fprintf(fid,'}\n\n');
fprintf(fid,'Vertices %8i\n', nverts);
for i=1:nverts
	fprintf(fid,'\t%10.6f %10.6f %10.6f\n', vertices(i,1), vertices(i,2), vertices(i,3));
end
fprintf(fid,'NBranchingPoints 0\n');
fprintf(fid,'NVerticesOnCurves 0\n');
fprintf(fid,'BoundaryCurves 0\n');
fprintf(fid,'Patches 1\n');
fprintf(fid,'{\n');
fprintf(fid,'InnerRegion Right_Cercus\n');
fprintf(fid,'OuterRegion Exterior\n');
fprintf(fid,'BoundaryID 0\n');
fprintf(fid,'BranchingPoints 0\n\n');
fprintf(fid,'Triangles %i\n', nfaces');
for i=1:nfaces
	fprintf(fid,'  %i %i %i\n', faces(i,1), faces(i,2), faces(i,3));
end
fprintf(fid,'}\n');
fclose(fid);

% If landmarks exists then write them to a separate file in Amira format
nVarargs = length(varargin);
if nVarargs == 1
    disp('writing landmarks');
    landmarks = varargin{1};
    numLandmarks = size(landmarks,1);
    fileString = fullfile(fdir, strcat(fname,'.landmarkAscii'));
    fid = fopen(fileString,'w');
    fprintf(fid,'# AmiraMesh 3D ASCII 2.0\n\n\n');
    fprintf(fid,'define Markers %i\n', numLandmarks);
    fprintf(fid,'Parameters {\n    NumSets 1,\n    ContentType \"LandmarkSet\"\n}\n\nMarkers { float[3] Coordinates } @1\n\n# Data section follows\n@1\n');
    for i=1:numLandmarks
        fprintf(fid,'%.10e %.10e %.10e\n', landmarks(i,1), landmarks(i,2), landmarks(i,3));
    end
    fclose(fid);
end
%disp('outputToAmira finished');
return;