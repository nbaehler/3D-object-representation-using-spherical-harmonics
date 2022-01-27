function verts = call_locsmo(param_vs, obj_vs, faces, extents, reso);
    % call locsmo.exe
    %

    vnum = size(param_vs, 1); fnum = size(faces, 1);
    % save to infile
    disp(sprintf('save param_vs, obj_vs, faces, extents, reso to infile ...'));
    fid = fopen('infile', 'wb');
    fwrite(fid, [reso vnum fnum], 'int');
    fwrite(fid, extents, 'double');
    fwrite(fid, param_vs, 'double');
    fwrite(fid, obj_vs, 'double');
    fwrite(fid, faces, 'int');
    fclose(fid);

    % remove remeshout
    if exist('outfile')
        !del outfile
        % !rm outfile %TODO switch for linux

    end

    !spa infile outfile 4

    % !wine spa infile outfile 4 %TODO switch for linux

    % read from outfile
    disp(sprintf('read verts from outfile ...'));
    fid = fopen('outfile', 'r');
    verts = fread(fid, vnum * 3, 'double');
    verts = reshape(verts, size(param_vs));
    fclose(fid);

    return;
