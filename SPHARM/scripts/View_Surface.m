% View surface script

clear;
flag = 'Yes';

while (strcmp(flag, 'Yes'))

    % Choose file of surface to view
    [inFile, inDir, n] = uigetfile('*.*', 'Open Surface File');
    fileString = fullfile(inDir, inFile);
    fileString = deblank(fileString);
    [path, name, ext] = fileparts(fileString);

    load(fileString);

    info = str2num('0 30 32'); dg = info(1:2); meshsize = info(3);

    gen_view('disp_spharm_desc', fvec, meshsize, dg, path, name, [], 0);

    flag = questdlg('Show another surface?');

end;
