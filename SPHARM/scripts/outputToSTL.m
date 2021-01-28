function outputToSTL(fdir, fname, vertices, faces, varargin)
% This function outputs a surface triangular mesh and landmarks to a
% standard ASCII STL formatted file.  
%
% If landmarks are passed as the first varargin, the landmarks are output 
% as a separate file with the same name, but .landmarkAscii file extension.

fileString = fullfile(fdir, strcat(fname, '.STL'));

disp(fileString);
[nverts, a] = size(vertices);
[nfaces, a] = size(faces);

% output surface to Amira formatted file.
fid = fopen(fileString,'w');
fprintf(fid,'solid %s\n', fileString);
% print for each face
for i=1:nfaces
    % first find vertices
    v1 = faces(i,1);
    v2 = faces(i,2);
    v3 = faces(i,3);
    vert1 = vertices(v1,:);    
    vert2 = vertices(v2,:);    
    vert3 = vertices(v3,:);    
    % calculate normal
    vec1 = vert2 - vert1;
    vec2 = vert3 - vert1;
    vec3 = cross(vec1',vec2');
    normal = vec3 ./ sqrt(sum(vec3' .* vec3'));  % make it unit length
    % write facet to file
    fprintf(fid,'  facet normal %.6f %.6f %.6f\n', normal(1), normal(2), normal(3));
    fprintf(fid,'    outer loop\n');
    fprintf(fid,'      vertex %.6f %.6f %.6f\n', vert1(1,1), vert1(1,2), vert1(1,3));
    fprintf(fid,'      vertex %.6f %.6f %.6f\n', vert2(1,1), vert2(1,2), vert2(1,3));
    fprintf(fid,'      vertex %.6f %.6f %.6f\n', vert3(1,1), vert3(1,2), vert3(1,3));
    fprintf(fid,'    endloop\n');
    fprintf(fid,'  endfacet\n');
end
fprintf(fid,'endsolid %s\n', fileString);
fclose(fid);

% If landmarks exists then write them to a separate file in Amira format
nVarargs = length(varargin);
if nVarargs == 1
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
return;