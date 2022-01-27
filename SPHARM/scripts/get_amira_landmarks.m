function ldmk = get_amira_landmarks(fname)
    % Goal: read landmarks from Amira output file
    % landmarks are in [x,y,z] coordinates
    %
    % Li Shen
    % 07/16/2007 - create

    ldmk = [];

    disp(fname);

    fid = fopen(fname);

    % return an empty set of landmarks if no landmark file is present.
    if (fid == -1)
        return
    end

    while 1
        tline = fgetl(fid);
        if ~ischar(tline), break, end
        a = str2num(tline);

        if ~isempty(a)
            ldmk(end + 1, :) = a;
        end

    end

    fclose(fid);

    return;
