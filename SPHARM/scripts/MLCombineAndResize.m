function [currentDir] = MLCombineAndResize(currentDir, x, y, z)
    % Combine vertices, faces and landmarks in one file and resize object.
    % The user is prompted to select >=1 triangular mesh files from the disk as
    % input.  Each file must also have an associated file of landmarks with the
    % same file name, but with the file extension '.landmarksAscii' in the same
    % directory.  These files are processed one at a time.  First, the
    % vertices, faces and landmarks are read from the disk files.  The vertices
    % and landmarks are then centered on the origin.
    %
    % The object and landmark positions are then rescaled according to the
    % input parameter x as follows:
    % x=0, No Size Rescaling
    % x=1, Centroid Size -- The object is rescaled to have a centroid size = 1.
    % x=2, Distance Size -- The object is rescaled to have a
    %                                   specified distance = 1.
    %
    % If x=2, then the landmark vertex indices in the [n,2] array y are used to
    % calculate the scaling distance of the object.  y must contain n pairs of
    % landmark indices.  The distance between the landmarks identified by each
    % pair of indices will be calculated, and the sum of this distance will be
    % used as the rescaling factor.
    %
    % z is a flag for writing sizes to an output file.

    disp('INSIDE MLCombineAndResize.');
    % set incoming parameters
    resize = x;
    landmarksForDistances = y;
    sizesToFile = z;
    [numLandmarkDists a] = size(landmarksForDistances);

    %currentDir = '.';
    [names, currentDir] = uigetfile({'*.m', 'Matlab .m files'; '*.stl', 'STL ASCII files'}, 'Select Files to Make SPHARM models', currentDir, 'MultiSelect', 'on');
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

    % get file to write sizes as data
    if (sizesToFile)
        [outputTextFileName, textDir, fi] = uiputfile({'*.*', 'All Files'}, 'Output size data as text.', currentDir);

        if (isnumeric(outputTextFileName))
            disp('No files chosen to output.');
            toFile = 0;
        else
            outputTextFile = fullfile(textDir, outputTextFileName);
            fid = fopen(outputTextFile, 'w');

            if (resize == 1)
                fprintf(fid, 'Centroid Sizes\n');
            elseif (resize == 2)
                fprintf(fid, 'Linear Sizes\n');
            end

        end

    end

    % Process files
    for i = 1:n;

        if (moreThanOneFile)
            file = fullfile(currentDir, names{i});
        else
            file = fullfile(currentDir, names);
        end

        file = deblank(file);
        [currentDir, name, ext] = fileparts(file);
        disp([' processing ' name ext]);

        if (strcmpi(ext, '.m'))
            [vertices, faces, landmarks] = readObjectStructureFromMFile(file);
        elseif (strcmpi(ext, '.stl'))
            [vertices, faces, landmarks] = readObjectStructureFromSTLFile(file);
        end

        % if landmarks were not in file, they must be in another file.
        if (isempty(landmarks))
            disp('no landmarks in file, so had to read them from disk');
            % make landmark file name & read them in
            landmarks_filename = strcat(name, '.landmarkAscii');
            landmarks = get_amira_landmarks(fullfile(currentDir, landmarks_filename));
            % if no landmarks are returned, that means that no landmarks are
            % available for this mesh and so all processing of it should stop
            if (isempty(landmarks))
                errormsg = ['No landmarks can be found for ' name ext '\nProcessing on this mesh will end.'];
                errordlg(errormsg, 'No Landmarks', 'modal');
                continue
            end

            newName = [name '_OL'];
        end

        % calculate centroid
        centroid = mean(vertices);
        % Move objects and landmarks to origin
        [nverts, a] = size(vertices);
        [nlandmarks, a] = size(landmarks);
        holdCent = centroid;

        for j = 2:nverts
            holdCent = [holdCent; centroid];
        end

        vertices = vertices - holdCent;
        holdCent(1:nlandmarks, :);
        landmarks = landmarks - holdCent(1:nlandmarks, :);
        newName = [newName '_2O'];

        % calculate rescale size factors if necessary
        centroidSize = sqrt(sum(sum(vertices' .* vertices')')); % New way to calculate centroid size changed in version 1.1
        %   centroidSize = sqrt(trace(vertices * vertices'));          % Old way of calulating centroid size
        if (resize > 0)

            if (resize == 1)
                %disp('Resizing by Centroid Size.');
                rescaleSize = centroidSize;
                newName = [newName '_CS'];
            elseif (resize == 2)
                %disp('Resizing by Distances.');
                rescaleSize = 0.0;

                if (numLandmarkDists < 1)
                    errordlg('No landmark distances specified', 'Wrong Input', 'modal');
                    return
                end

                for j = 1:numLandmarkDists
                    diff = landmarks(landmarksForDistances(j, 1), :) - landmarks(landmarksForDistances(j, 2), :);
                    rescaleSize = rescaleSize + sqrt(diff * diff');
                end

                newName = [newName '_DS'];
            end

            vertices = vertices / rescaleSize;
            landmarks = landmarks / rescaleSize;
        end

        if (sizesToFile)
            fprintf(fid, '%s\t%f\n', newName, rescaleSize);
        end

        % output vertices, faces, landmarks and centroidSize as a structure in an .m file
        newName = [newName '.mat'];
        outFile = fullfile(currentDir, newName);
        save(outFile, 'vertices', 'faces', 'landmarks', 'centroidSize');
    end

    % close output file if it was opened.
    if (sizesToFile)
        fprintf(fid, '\n');
        fclose(fid);
    end

    disp('MLCombineAndResize finished.');
end

function [vertices, faces, landmarks] = readObjectStructureFromMFile(fname)
    % Read triangular mesh from an m file
    % Reads a triangular mesh containing vertices, faces and landmarks from a
    % .m file that contains these variables in a structure in Matlab format.
    % The function assumes that these variables come in the order of
    % 'vertices', then 'faces' and then 'landmarks'.  They must also be
    % identified by these variable names with all lowercase.  The variables
    % 'vertices' and 'faces' must be present, but 'landmarks' are optional.

    % %debugging------------------
    % clear;
    % path = '.';
    %
    % % get file to make template from disk
    % [name, currentDir] = uigetfile({'*.m','Matlab .m files'},'Select File to Make Template',path);
    % fullFileName = fullfile(currentDir, name);
    % disp(name);
    % disp(fullFileName);
    % [currentDir, name, ext] = fileparts(fullFileName);
    % fname = fullFileName;
    % %debugging------------------
    %

    vertices = [];
    faces = [];
    landmarks = [];

    disp(fname);

    fid = fopen(fname);

    while 1
        tline = fgetl(fid);
        % test for end of file
        if (~ischar(tline))
            break
        end

        %if line is empty
        if (strcmp(tline, ''))
            continue
        end

        % if line is a comment, pass by
        if (strcmp(tline(1), '%'))
            continue
        end

        % found beginning of structure
        if (strcmp(tline(1:7), 'surface'))
            % find if vertices is located in this line
            k = strfind(tline, '''vertices''');

            if (isempty(k))
                errordlg('File does not contain vertices first.', 'Wrong file format.', 'modal');
                break
            end

            % line contains vertices, so get first data
            startIndex = regexp(tline, '[');
            endIndex = regexp(tline, ';');
            a = str2num(tline((startIndex + 1):(endIndex - 1)));
            vertices(end + 1, :) = a;
            % get rest of vertices
            while 1
                tline = fgetl(fid);

                if (strcmp(tline(1), ']'))
                    % go on to find faces
                    break
                end

                % another line of data
                endIndex = regexp(tline, ';');

                if (~isempty(endIndex)) % pass over empty lines
                    a = str2num(tline(1:(endIndex - 1)));
                    vertices(end + 1, :) = a;
                end

            end

            % get faces
            k = strfind(tline, '''faces''');

            if (isempty(k))
                errordlg('File does not contain faces after vertices.', 'Wrong file format.', 'modal');
                break
            end

            % line contains vfaces, so get first data
            startIndex = regexp(tline, '[');
            endIndex = regexp(tline, ';');
            a = str2num(tline((startIndex + 1):(endIndex - 1)));
            faces(end + 1, :) = a;
            % get rest of faces
            while 1
                tline = fgetl(fid);

                if (strcmp(tline(1), ']'))
                    % go on to find landmarks
                    break
                end

                % another line of data
                endIndex = regexp(tline, ';');

                if (~isempty(endIndex)) % pass over empty lines
                    a = str2num(tline(1:(endIndex - 1)));
                    faces(end + 1, :) = a;
                end

            end

            % get landmarks
            k = strfind(tline, '''landmarks''');

            if (isempty(k))
                % no landmarks so we're done
                break
            end

            % line contains landmarks, so get first data
            startIndex = regexp(tline, '[');
            endIndex = regexp(tline, ';');
            a = str2num(tline((startIndex + 1):(endIndex - 1)));
            landmarks(end + 1, :) = a;
            % get rest of landmarks
            while 1
                tline = fgetl(fid);

                if (strcmp(tline(1), ']'))
                    % go on to find landmarks
                    break
                end

                % another line of data
                endIndex = regexp(tline, ';');

                if (~isempty(endIndex)) % pass over empty lines
                    a = str2num(tline(1:(endIndex - 1)));
                    landmarks(end + 1, :) = a;
                end

            end

        end

    end

    fclose(fid);

end

function [vertices, faces, landmarks] = readObjectStructureFromSTLFile(filename)
    % Reads CAD STL ASCII files, which most CAD programs can export.
    % Used to create Matlab patches of CAD 3D data.
    % Returns a vertex list and face list, for Matlab patch command.
    %
    % filename = 'hook.stl';  % Example file.
    %
    % This function was taken from the MathWorks website in CAD2MATDEMO.M file
    % exchange posted by Don Riley on 23 June 2003.

    fid = fopen(filename, 'r'); %Open the file, assumes STL ASCII format.

    if fid == -1
        error('File could not be opened, check name or path.')
    end

    vertices = [];
    faces = [];
    landmarks = [];

    % fuzz is the minimum distance that a vertex must be from another vertex to
    % be considered a different vertex
    fuzz = 10^(-25);

    %
    % Render files take the form:
    %
    %solid BLOCK
    %  color 1.000 1.000 1.000
    %  facet
    %      normal 0.000000e+00 0.000000e+00 -1.000000e+00
    %      normal 0.000000e+00 0.000000e+00 -1.000000e+00
    %      normal 0.000000e+00 0.000000e+00 -1.000000e+00
    %    outer loop
    %      vertex 5.000000e-01 -5.000000e-01 -5.000000e-01
    %      vertex -5.000000e-01 -5.000000e-01 -5.000000e-01
    %      vertex -5.000000e-01 5.000000e-01 -5.000000e-01
    %    endloop
    % endfacet
    %
    % The first line is object name, then comes multiple facet and vertex lines.
    % A color specifier is next, followed by those faces of that color, until
    % next color line.
    %
    CAD_object_name = sscanf(fgetl(fid), '%*s %s'); %CAD object name, if needed.
    %                                                %Some STLs have it, some don't.
    report_num = 0; %Report the status as we go.

    while (feof(fid) == 0) % test for end of file, if not then do stuff
    tline = fgetl(fid); % reads a line of data from file.
    fword = sscanf(tline, '%s '); % make the line a character string
    fword = strtrim(fword); % remove whitespace at beginning and end of string

    % find facet start
    if strncmpi(fword, 'facet', 5)
        report_num = report_num + 1; % Report a counter, so long files show status

        if report_num > 2499;
            disp(sprintf('Reading facet num: %d.', size(faces, 1)));
            report_num = 0;
        end

        count = 0;
        v = zeros(3, 3);
        % get the three vertices
        while (count < 3)
            tline = fgetl(fid); % reads a line of data from file.
            %            fword = sscanf(tline, '%s ')       % make the line a character string
            fword = strtrim(tline); % remove whitespace at beginning and end of string

            if strncmpi(fword, 'vertex', 6)
                count = count + 1;
                a = str2num(fword(7:end));

                if (count == 1)
                    v(1, 1:3) = a;
                elseif (count == 2)
                    v(2, 1:3) = a;
                elseif (count == 3)
                    v(3, 1:3) = a;
                end

            end

        end

        % find the three vertices in the list of vertices found so far.
        if (isempty(vertices))
            % this is the first face
            vertices(1, :) = v(1, :);
            vertices(2, :) = v(2, :);
            vertices(3, :) = v(3, :);
            faces(1, :) = [1 2 3];
        else
            faces(end + 1, :) = [0 0 0];
            numVerts = size(vertices, 1);
            found1 = 0;
            found2 = 0;
            found3 = 0;

            for m = 1:numVerts
                % get a previous vertex
                a = vertices(m, :);
                v(1, :);
                % calculate distances from this vertex to the three
                % vertices just read in
                dist1 = sqrt((a - v(1, :)) * (a - v(1, :))');
                dist2 = sqrt((a - v(2, :)) * (a - v(2, :))');
                dist3 = sqrt((a - v(3, :)) * (a - v(3, :))');

                if ((dist1 < fuzz) && ~found1)
                    faces(end, 1) = m;
                    found1 = 1;
                end

                if ((dist2 < fuzz) && ~found2)
                    faces(end, 2) = m;
                    found2 = 1;
                end

                if ((dist3 < fuzz) && ~found3)
                    faces(end, 3) = m;
                    found3 = 1;
                end

            end

            if (~found1)
                vertices(end + 1, :) = v(1, :);
                faces(end, 1) = size(vertices, 1);
            end

            if (~found2)
                vertices(end + 1, :) = v(2, :);
                faces(end, 2) = size(vertices, 1);
            end

            if (~found3)
                vertices(end + 1, :) = v(3, :);
                faces(end, 3) = size(vertices, 1);
            end

        end

    end % end processing a facet

    % Check for color
    %     if strncmpi(fword, 'v',1) == 1;    % Checking if a "V"ertex line, as "V" is 1st char.
    %        vnum = vnum + 1;                % If a V we count the # of V's
    %        v(:,vnum) = sscanf(tline, '%*s %f %f %f'); % & if a V, get the XYZ data of it.
    %        c(:,vnum) = VColor;              % A color for each vertex, which will color the faces.
    %     end                                 % we "*s" skip the name "color" and get the data.
end

% close file
fclose(fid);
end
