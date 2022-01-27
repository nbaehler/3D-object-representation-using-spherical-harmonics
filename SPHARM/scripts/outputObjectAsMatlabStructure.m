function outputObjectAsMatlabStructure(fileString, vertices, faces, landmarks)
    % This function outputs a surface triangular mesh as a Matlab .m file.
    % The format is as a structure containing vertices, faces and landmarks.

    [nverts, a] = size(vertices);
    [nfaces, a] = size(faces);
    [nlandmarks, a] = size(landmarks);

    % output surface to Amira formatted file.
    fid = fopen(fileString, 'w');

    fprintf(fid, 'surface = struct(''vertices'', [');

    for i = 1:nverts
        fprintf(fid, '%.6f %.6f %.6f; ...\n', vertices(i, 1), vertices(i, 2), vertices(i, 3));
    end

    fprintf(fid, '], ''faces'', [');

    for i = 1:nfaces
        fprintf(fid, '%i %i %i; ...\n', faces(i, 1), faces(i, 2), faces(i, 3));
    end

    fprintf(fid, '], ''landmarks'', [');

    for i = 1:nlandmarks
        fprintf(fid, '%.6f %.6f %.6f; ...\n', landmarks(i, 1), landmarks(i, 2), landmarks(i, 3));
    end

    fprintf(fid, ']);\n');

    fclose(fid);

    return;
