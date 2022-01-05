function [currentDir] = MLMakeAverageModel(dir, outputShapeToFile, meshsize, outputFormat, surfFilename)
    % function MLMakeAverageModel()
    % Read in a set of registered SPHARM objects (i.e., those with *_reg.mat"
    % files), and calculate the average object from this set using the SPHARM
    % coefficients, and also calculate the average locations of the landmarks
    % from these same objects.  This "average" object is then output to a new
    % file containing the average SPHARM model of coefficients, and the
    % vertices, faces and landmarks that go along with this average object.

    disp('INSIDE MLMakeAverageModel.');
    % set incoming parameters

    [names, dir] = uigetfile({'*reg.mat', 'Matlab *reg.mat files'}, 'Select Files to Make the average SPHARM model', dir, 'MultiSelect', 'on');
    [fake, n] = size(names);
    moreThanOneFile = iscell(names);

    if (isnumeric(names))
        disp('No files chosen to Combine & Resize.');
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
            file = fullfile(dir, names{i});
        else
            file = fullfile(dir, names);
        end

        file = deblank(file);

        load(file);
        clear('sph_verts', 'vertices', 'faces');
        % Collect up fvec and landmarks for each shape.

        %     [fvecRows, fvecCols] = size(fvec);
        %     fvec = reshape(fvec, 1, (fvecRows*fvecCols));
        %     [lmRows, lmCols] = size(landmarks);
        %     landmarks = reshape(landmarks, 1, (lmRows*lmCols));
        if (i == 1)
            holdFvec = fvec;
            holdLandmarks = landmarks;
        else
            holdFvec = holdFvec + fvec;
            holdLandmarks = holdLandmarks + landmarks;
        end

    end

    % calculate average shape
    fvec = (1 / n) * holdFvec;
    % fvec = reshape(fvec, fvecRows, fvecCols);
    landmarks = (1 / n) * holdLandmarks;
    % landmarks = reshape(landmarks, lmRows, lmCols);

    [vertices, faces] = surf_spharm(fvec, dg, meshsize);

    % write average model to file
    modelFilename = [surfFilename '.mat'];
    save(fullfile(dir, modelFilename), 'fvec', 'vertices', 'faces', 'landmarks', 'dg');

    % save shape to file if told to do so from input
    if (outputShapeToFile == 1)
        % Save average surface to file for visualization
        switch outputFormat % format to use for output
            case 'Amira'
                outputToAmira(dir, surfFilename, vertices, faces, landmarks);
            case 'STL'
                outputToSTL(dir, surfFilename, vertices, faces, landmarks);
            otherwise % Amira output is default
                outputToAmira(dir, surfFilename, vertices, faces, landmarks);
        end

    end

    currentDir = dir;

    % patch_lighta(vertices, faces);
    % axis off;  view(3);
    % hold on;
    % P1 = landmarks; plot3(P1(:,1),P1(:,2),P1(:,3),'k.','MarkerSize',50); hold off;
    % title('average surface');
    %
    disp('MLMakerAverageModel finished.');
end
