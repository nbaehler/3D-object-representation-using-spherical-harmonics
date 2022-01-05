function [currentDir] = MLMakeModels(currentDir, x, y, z)
    % Make SPHARM models.
    % MLMakeModels reads a template file that has been previously processed
    % by MLMakeTemplate and an array of files to process that are specified
    % in '.\matlabFileList.m'.  These files contain triangular mesh objects
    % stored in .m format.  These files are assumed to have been standardized
    % by size before being passed to this function.  Each must contain, the
    % same number of vertices, faces and landmarks.  Each file listed in the
    % array is smoothed is set to 1 and then a SPHARM model is calculated to
    % the degree specified.  The parameter mesh is then registered to the
    % template.
    %
    %   The logical flow of the function is as follows:
    %
    %   1. The object is smoothed (if the smooth parameter x passed to the
    %   function has x=1).  The object created in this smoothing step is saved
    %   in a file that has "_smo.mat" appended to the end of the file name.  If
    %   smooth=0 is passed to the function (i.e., parameter x=0), the function
    %   assumes that the file passed to it has already been smoothed.
    %
    %   2. The spherical harmonic (SPHARM) descriptor is then created.  First,
    %   improve_res function is called to potentially add vertices in areas
    %   with poor resolution.  Then spharm_vec is called where the actual
    %   SPHARM model is constructed and returned.  This is in the form of a
    %   vector of spherical harmonic coefficients of size (info(1,1)+1)^2 -
    %   fvec.  This number should be the same as that used to create the
    %   template.
    %
    %   3. The object is then registered to the template object.
    %
    %   A new file is written to the disk containing the original set of
    %   vertices, faces & landmarks as well as fvec, the set of corresponding
    %   vertices on the unit circle (sph_verts), and the degrees of the
    %   spherical harmonic reconstruction (dg).  The file is named by appending
    %   the degrees of the reconstruction and then "_des.mat" to the end.

    disp('INSIDE MLMakeModels');

    smooth = x;
    degree = y;
    toFile = z;

    % Set initial parameters
    maxfn = 10^6;
    switchcc = 0;
    % info(1,1) = the degrees of the spherical harmonics to reconstruct.
    % info(2,1) = the subdivision level specified in the reconstruction.
    info = [degree 0];

    % Get template File from disk
    [name, currentDir] = uigetfile({'template_*des.mat', 'Matlab template files'}, 'Select Template File to use', currentDir);

    if (isnumeric(name))
        disp('No files chosen for template in MLMakeModels.');
        currentDir = cd;
        return
    end

    templateFileName = fullfile(currentDir, name);

    % get file list from disk and smooth if necessary
    if (smooth == 1);
        [names, currentDir] = uigetfile({'*.mat', 'Matlab .mat files'}, 'Select Files to Make SPHARM models', currentDir, 'MultiSelect', 'on');
        [fake, n] = size(names);
        moreThanOneFile = iscell(names);

        if (isnumeric(names))
            disp('No files chosen, so function MLMakeModels is returning.');
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

    else
        [names, currentDir] = uigetfile({'*smo.mat', 'smoothed *smo.mat files'}, 'Load previously smoothed files to make SPHARM models', currentDir, 'MultiSelect', 'on');
        [fake, n] = size(names);
        moreThanOneFile = iscell(names);

        if (isnumeric(names))
            disp('No files chosen to Combine & Resize.');
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

    end

    % get file to write FVECS as data
    if (toFile)
        [outputTextFileName, textDir, fi] = uiputfile({'*.*', 'All Files'}, 'Output SPHARM Parameters as text.', currentDir);

        if (isnumeric(outputTextFileName))
            disp('No files chosen to output.');
            toFile = 0;
        else
            outputTextFile = fullfile(textDir, outputTextFileName);
            fid = fopen(outputTextFile, 'w');
        end

    end

    % do processing of each file
    for i = 1:n;

        if (moreThanOneFile)
            file = fullfile(currentDir, names{i});
        else
            file = fullfile(currentDir, names);
        end

        file = deblank(file);
        [currentDir, name, ext] = fileparts(file);
        disp([' processing ' name ext]);
        load(file);

        if ~exist('centroidSize', 'var')
            centroidSize = -1;
        end

        %-------------------------------------------------
        %  Do smoothing operation or load smoothed file
        %-------------------------------------------------
        if (smooth == 1)
            new_name = [name '_smo.mat'];
            % dateline, mesh_landmarks, metric just used for debugging by Li
            [sph_verts, vertices, faces, dateline, mesh_landmarks, metric] = ...
            smooth_surface(maxfn, switchcc, vertices, faces, name);
            % if statement to set centroidSize to -1 for legacy files that do
            % not contain the centroidSize
            save(fullfile(currentDir, new_name), 'sph_verts', 'vertices', 'faces', 'dateline', 'landmarks', 'centroidSize', 'metric');
        else
            % find out if file name ends in _smo and if so remove this.
            endName = name(end - 3:end);

            if (strcmp(endName, '_smo'))
                name = name(1:end - 4);
            end

        end

        %---------------------------------------------
        % Create Spherical Harmonic Descriptor
        %---------------------------------------------
        % dg gives degrees for the spherical harmonic parameterization.  From
        % this, the level of detail of the model reconstructions is determined.
        % dg(1) specifies the lowest frequency coefficient to include in the
        % model and dg(2) specifies the highest degree coefficient to include
        % in the model.
        dg = [0 info(1)];
        %     smo_cost = ones(1,4)*NaN;
        %     vertnum = size(vertices,1);
        %     facenum = size(faces,1);
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
        %   centroidSize: Centroid Size of original surface, this is passed on from the original resizing operation
        new_name = sprintf('%s_%d_%d_des.mat', name, d, info(2));
        save(fullfile(currentDir, new_name), 'fvec', 'sph_verts', 'vertices', 'faces', 'landmarks', 'dg', 'centroidSize');

        %
        %
        %     % for debugging purposes only. Output Amira surface of vertices and
        %     % faces.
        %     out_name = sprintf('%sdesRaw',new_name(1:end-7));
        %     outputToAmira(currentDir, out_name, vertices, faces, landmarks);
        %
        %

        %---------------------------------------------
        % Align To Template
        %---------------------------------------------
        % align to template object and landmarks if not making template and
        % write the results to an output file.  All this done in spharm_align
        % Mark McPeek, 6 October 2013 modified this to return rotated vertices
        % and landmarks in the registered model.  Previously, only the fvec was
        % rotated and translated to align with the template model.
        [fvec, vertices, landmarks] = spharm_align(currentDir, new_name, templateFileName);
        % write the aligned object and model to the disk
        new_name = sprintf('%sreg.mat', new_name(1:end - 7));
        save(fullfile(currentDir, new_name), 'fvec', 'sph_verts', 'vertices', 'faces', 'landmarks', 'dg', 'centroidSize');

        %
        %
        %     % for debugging purposes only. Output Amira surface of vertices and
        %     % faces.
        %     out_name = sprintf('%sregRaw',new_name(1:end-7));
        %     outputToAmira(currentDir, out_name, vertices, faces, landmarks);
        %

        %---------------------------------------------
        % Write model to collection file if applicable
        %---------------------------------------------
        % if model is to be written to disk as text, here's where
        if (toFile)
            fprintf(fid, new_name);
            [rows cols] = size(fvec);

            for k = 1:rows

                if (imag(fvec(k, 1)) < 0)
                    fprintf(fid, '\t%.9f %.9fi', real(fvec(k, 1)), imag(fvec(k, 1)));
                else
                    fprintf(fid, '\t%.9f +%.9fi', real(fvec(k, 1)), imag(fvec(k, 1)));
                end

                if (imag(fvec(k, 2)) < 0)
                    fprintf(fid, '\t%.9f %.9fi', real(fvec(k, 2)), imag(fvec(k, 2)));
                else
                    fprintf(fid, '\t%.9f +%.9fi', real(fvec(k, 2)), imag(fvec(k, 2)));
                end

                if (imag(fvec(k, 3)) < 0)
                    fprintf(fid, '\t%.9f %.9fi', real(fvec(k, 3)), imag(fvec(k, 3)));
                else
                    fprintf(fid, '\t%.9f +%.9fi', real(fvec(k, 3)), imag(fvec(k, 3)));
                end

                %            fprintf(fid,'\t%.9f %.9f\t%.9f %.9f\t%.9f %.9f', real(fvec(k,1)), imag(fvec(k,1)), real(fvec(k,2)), imag(fvec(k,2)), real(fvec(k,3)), imag(fvec(k,3)));
            end

            fprintf(fid, '\n');
        end

        clear('fvec', 'sph_verts', 'vertices', 'faces', 'landmarks', 'dg', 'centroidSize');
    end

    % close output file if it was opened.
    if (toFile)
        fprintf(fid, '\n');
        fclose(fid);
    end

    disp('MLMakeModels finished.');
end
