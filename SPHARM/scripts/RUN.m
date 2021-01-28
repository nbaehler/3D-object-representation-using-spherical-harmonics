disp('INSIDE RUN.');
workspace = '/home/nicolas/workspace/ma/misc/spharm-project/runs/trial_1/matlab_meshes/testing';
files = dir(workspace);
dirFlags = [files.isdir];
folders = {files(dirFlags).name};
degree = 8;

% Skip the folders '.' and '..'
for f = 3 : length(folders)
    baseName = char(folders(f));
    ext = '.m';
    inputFile = strcat(baseName,ext);
    crtDir = fullfile(workspace,baseName);
    
    % x=0, No Size Rescaling; x=1, Centroid Size; x=2, Distance Size
    % y, Landmark distances for resizing Pairs: [1 2; 2 3] for example
    % z, Output Sizes to File (bool)
    [~, translation] = AUTOMLCombineAndResize(crtDir, 0, '[]', 0, inputFile);
    
    ext = '.mat';
    baseName = strcat(char(folders(f)),'_OL');
    inputFile = strcat(baseName,ext);

    baseName = strcat('template_',baseName,'_');
    smoothFile = strcat(baseName,'smo',ext);

    % x, smooth (bool)
    % y, degree
    AUTOMLMakeTemplate(crtDir, 1, degree, inputFile, smoothFile);

    inputFile = strcat(baseName,num2str(degree),'_0_des',ext);

    % x, smooth (bool)
    % y, degree
    % z, toFile (bool)
    AUTOMLMakeModels(crtDir, 0, degree, 1, inputFile, smoothFile, translation);

    inputFile = strcat(baseName,num2str(degree),'_0_reg',ext);
    
    % x, meshsize
    % y='Amira'; 'STL', outputFormat
    AUTOMLMakeSurfacesFromSPHARMModels(crtDir, -5, 'STL', inputFile);
end

disp('RUN finished.');
