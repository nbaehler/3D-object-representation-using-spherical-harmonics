function [currentDir] = AUTOMLMakeSurfacesFromSPHARMModelsFromParameters(currentDir, x, y, inputFile, fvec, dg)
    % Reconstructs surfaces for viewing from SPHARM models.
    % This script reads in the resulting file from MLMakeModel.m, and
    % creates the spherical harmonic representation of the model from fvec
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
    % Underlying spherical mesh is the original object mesh mapped to the sphere

    meshsize = x;
    outputFormat = y;
    disp('INSIDE AUTOMLMakeSurfacesFromSPHARMModelsFromParameters.');

    [filepath, name, ext] = fileparts(inputFile);

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

    % make surface based on mesh picked
    [spharm_vertices, spharm_faces] = surf_spharm(fvec, dg, meshsize);

    landmarks = get_landmarks(spharm_vertices);

    switch outputFormat % format to use for output
        case 'Amira'
            outputToAmira(currentDir, [name suffix], spharm_vertices, spharm_faces, landmarks);
        case 'STL'
            outputToSTL(currentDir, [name suffix], spharm_vertices, spharm_faces, landmarks);
        otherwise % Amira output is default
            outputToAmira(currentDir, [name suffix], spharm_vertices, spharm_faces, landmarks);
    end

    clear spharm_vertices spharm_faces;

    disp('MLMakeSurfacesFromSPHARMModels finished.');
end

function [landmarks] = get_landmarks(spharm_vertices)
    [~, x_min] = min(spharm_vertices(:, 1));
    [~, x_max] = max(spharm_vertices(:, 1));
    [~, y_min] = min(spharm_vertices(:, 2));
    [~, y_max] = max(spharm_vertices(:, 2));
    [~, z_min] = min(spharm_vertices(:, 3));
    [~, z_max] = max(spharm_vertices(:, 3));
    center = mean(spharm_vertices);

    landmarks = [spharm_vertices(x_min, :);
            spharm_vertices(x_max, :);
            spharm_vertices(y_min, :);
            spharm_vertices(y_max, :);
            spharm_vertices(z_min, :);
            spharm_vertices(z_max, :);
            center];
end
