disp('INSIDE RUN CHECK.');
workspace = '/home/nicolas/workspace/ba6/spharm-project/runs/trial_1/matlab_meshes/training';
files = dir(workspace);
dirFlags = [files.isdir];
folders = {files(dirFlags).name};
degree = 10000;

% Skip the folders '.' and '..'
for f = 3 : length(folders)        
    baseName = char(folders(f));
    ext = '.m';
    inputFile = strcat(baseName,ext);
    crtDir = fullfile(workspace,baseName);
    
    % x=0, No Size Rescaling; x=1, Centroid Size; x=2, Distance Size
    % y, Landmark distances for resizing Pairs: [1 2; 2 3] for example
    % z, Output Sizes to File (bool)
    AUTOMLCombineAndResize(crtDir, 0, '[]', 0, inputFile);
    
    ext = '.mat';
    baseName = strcat(baseName,'_OL');
    inputFile = strcat(baseName,ext);

    baseName = strcat('template_',baseName,'_');
    smoothFile = strcat(baseName,'smo',ext);

    % x, smooth (bool)
    % y, degree
    try 
        AUTOMLMakeTemplate(crtDir, 1, degree, inputFile, smoothFile);
    catch
        rmdir(crtDir,'s');
        continue;
    end
    
    resultFile = strcat(baseName,num2str(degree),'_0_des',ext);
    
    if ~exist(resultFile, 'file')
        files = dir(crtDir);
        for i = 3 : length(files)
            file = char(files(i).name);
            disp(file);
            if contains(file, '_0_des.mat')
                deg = erase(file, baseName);
                deg = erase(deg, '_0_des.mat');
                degree = str2num(deg);
                delete(strcat(crtDir, '/', file));
            elseif isempty(regexp(file, '\w+.m$', 'once'))
                delete(strcat(crtDir, '/', file));
            end
        end      
    end
end

disp(strcat('==> minimum degree=',num2str(degree)));

disp('RUN CHECK finished.');
