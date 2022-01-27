disp('INSIDE RUN INVERSE.');

workspace = 'C:\Users\baehl\Downloads\working_evaluations\';
% workspace = '/home/nicolas/Downloads/evaluations/';
sep = '\'
% sep = '/'

files = dir(workspace);
dirFlags = [files.isdir];
iterations = {files(dirFlags).name};

% Skip the folders '.' and '..'
for iter = 3:length(iterations)
    crtDir = fullfile(workspace, char(iterations(iter)));
    files = dir(fullfile(crtDir, '*.txt'));
    fileFlags = ~[files.isdir];
    samples = {files(fileFlags).name};

    for s = 1:length(samples)
        inputFile = char(samples(s));

        fvec = {{}};
        i = 1;
        fid = fopen(strcat(crtDir, sep, inputFile));
        line = fgetl(fid);

        while ischar(line)
            coeffs = strsplit(line);

            fvec{i, 1} = complex(str2double(coeffs(1)), str2double(coeffs(2)));
            fvec{i, 2} = complex(str2double(coeffs(3)), str2double(coeffs(4)));
            fvec{i, 3} = complex(str2double(coeffs(5)), str2double(coeffs(6)));

            i = i + 1;
            line = fgetl(fid);
        end

        fclose(fid);

        fvec = cell2mat(fvec);
        dg = [0 sqrt(i - 1) - 1];

        % x, meshsize
        % y='Amira'; 'STL', outputFormat
        AUTOMLMakeSurfacesFromSPHARMModelsFromParameters(crtDir, -5, 'STL', inputFile, fvec, dg);
    end

end

disp('RUN finished.');
