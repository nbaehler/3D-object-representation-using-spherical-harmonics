% This script reads in .m file and outputs the .m file in STL format.
function MFileToSTL()
    clear;
    disp(' ');

    % Identify file with fvecs to process
    [filename, path] = uigetfile({'*.m'; '*.*'}, 'pick .m file');

    file = fullfile(path, filename);
    file = deblank(file);
    [currentDir, name, ext] = fileparts(file);
    disp([' processing ' name ext]);

    [vertices, faces, landmarks] = readObjectStructureFromMFile(file);

    outputToSTL(currentDir, name, vertices, faces, landmarks)

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
