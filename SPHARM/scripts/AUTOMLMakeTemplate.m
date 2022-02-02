function [currentDir] = AUTOMLMakeTemplate(currentDir, x, y, inputFile, smoothFile)
    %   MLMakeTemplate reads a single file that is specified in
    %   '.\matlabFileList.m' that contains an triangular mesh object, and
    %   created s SPHARM template file from it.
    %
    %   The logical flow of the function is as follows:
    %
    %   1. The object is smoothed (if the smooth parameter x passed to the
    %   function has x=1).  The object created in this smoothing step is saved
    %   in a file that has "template_" appended to the beginning of the file
    %   name, and "_smo.mat" appended to the end of the file name.  If smooth
    %   =0 is passed to the function (i.e., parameter x=0), the function
    %   assumes that the file passed to it has already been smoothed.
    %
    %   2. The spherical harmonic (SPHARM) descriptor is then created.  First,
    %   improve_res function is called to potentially add vertices in areas
    %   with poor resolution.  Then spharm_vec is called where the actual
    %   SPHARM model is constructed and returned.  This is in the form of a
    %   vector of spherical harmonic coefficients of size (info(1,1)+1)^2 -
    %   fvec.
    %
    %   A new file is written to the disk containing the original set of
    %   vertices, faces & landmarks as well as fvec, the set of corresponding
    %   vertices on the unit circle (sph_verts), and the degrees of the
    %   spherical harmonic reconstruction (dg).  The file is named by appending
    %   "template_" to the beginning of the file name, and appending the
    %   degrees of the reconstruction and then "_des.mat" to the end.

    disp('INSIDE MLMakeTemplate');

    smooth = x;
    degree = y;

    % parameters
    maxfn = 10^6;
    switchcc = 0;
    % info(1,1) = the degrees of the spherical harmonics to reconstruct.
    info = [degree 0];

    % get file to make template from disk
    name = inputFile;

    if (isnumeric(name))
        disp('No files chosen for template in MLMakeTemplate.');
        currentDir = cd;
        return
    end

    fullFileName = fullfile(currentDir, name);
    disp(name);
    disp(fullFileName);
    [currentDir, name, ~] = fileparts(fullFileName);
    load(fullFileName);
    % faces = surface.faces(:,:);
    % vertices = surface.vertices(:,:);
    % landmarks = surface.landmarks(:,:);

    % % reclaim space from surface
    % clear surface;

    disp(['processing ' name]);

    %-------------------------------------------------
    %  Do smoothing operation.
    %-------------------------------------------------
    % If smooth =0 the algorithm assumes that the user has loaded the
    % *_smo.mat" file here.
    if (smooth == 1)
        name = ['template_' name];
        new_name = [name '_smo.mat'];
        % dateline, mesh_landmarks, metric just used for debugging by Li
        [sph_verts, vertices, faces, dateline, ~, metric] = ...
        smooth_surface(maxfn, switchcc, vertices, faces, name);
        save(fullfile(currentDir, new_name), 'sph_verts', 'vertices', 'faces', 'dateline', 'landmarks', 'metric');
    else
        vars = load(fullfile(currentDir, smoothFile), 'sph_verts', 'vertices', 'faces');
        sph_verts = vars.sph_verts;
        vertices = vars.vertices;
        faces = vars.faces;

        % find out if file name ends in '_smo' and if so remove this.
        endName = name(end - 3:end);

        if (strcmp(endName, '_smo'))
            name = name(1:end - 4);
        end

        % find out if the start of the file name is 'template_' and if not add it
        startName = name(1:9);

        if (~strcmp(startName, 'template_'))
            name = ['template_' name];
        end

    end

    %---------------------------------------------
    % Create Spherical Harmonic Descriptor
    %---------------------------------------------
    % dg gives degrees for the spherical harmonic parameterization.  From
    % this, the level of detail of the model reconstructions is determined.
    dg = [0 info(1)];
    % smo_cost = ones(1,4)*NaN;
    % vertnum = size(vertices,1);
    % facenum = size(faces,1);
    [evs, svs] = improve_res(vertices, sph_verts, faces, info(2));

    % create spharm descriptor
    % fvec = is the vector of spherical harmonic coefficients of size (info(1,1)+1)^2
    [fvec, d] = spharm_vec(evs, svs, info(1));
    dg(2) = d;

    % This file stores the following variables:
    % 	fvec: vector of spherical harmonic coefficients of size (info(1,1)+1)^2
    % 	sph_verts: vertices on the unit sphere
    % 	vertices: vertex locations on the structure
    % 	faces: connections between vertices to make triangular mesh
    % 	landmarks: the original landmark set
    % 	dg: degrees of the spherical harmonic reconstruction
    new_name = sprintf('%s_%d_%d_des.mat', name, d, info(2));
    save(fullfile(currentDir, new_name), 'fvec', 'sph_verts', 'vertices', 'faces', 'landmarks', 'dg');

    disp('MLMakeTemplate finished.');
end
