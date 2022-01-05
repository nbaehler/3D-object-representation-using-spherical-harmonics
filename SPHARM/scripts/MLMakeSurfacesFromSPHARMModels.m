function [currentDir] = MLMakeSurfacesFromSPHARMModels(currentDir, x, y)
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
    disp('INSIDE MLMakeSurfacesFromSPHARMModels.');

    [names, currentDir] = uigetfile({'*.mat', 'Matlab .mat files'}, 'Select SPHARM model Files', currentDir, 'MultiSelect', 'on');
    [fake, n] = size(names);
    moreThanOneFile = iscell(names);

    if (isnumeric(names))
        disp('No files chosen to Make Surfaces From SPHARM Models.');
        currentDir = cd;
        return
    else

        if moreThanOneFile

            for i = 1:n
                disp(names{i});
            end

        else
            n = 1;
            disp(names);
        end

    end

    for i = 1:n;

        if (moreThanOneFile)
            file = fullfile(currentDir, names{i});
        else
            file = fullfile(currentDir, names);
        end

        file = deblank(file);
        [currentDir, name, ext] = fileparts(file);
        load(file);

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

        switch outputFormat % format to use for output
            case 'Amira'
                outputToAmira(currentDir, [name suffix], spharm_vertices, spharm_faces, landmarks);
            case 'STL'
                outputToSTL(currentDir, [name suffix], spharm_vertices, spharm_faces, landmarks);
            otherwise % Amira output is default
                outputToAmira(currentDir, [name suffix], spharm_vertices, spharm_faces, landmarks);
        end

        clear spharm_vertices spharm_faces;
    end

    disp('MLMakeSurfacesFromSPHARMModels finished.');
end
