function obj_fun = cal_obj_fun(verts, faces, obj_area)
    % calculate objective function
    %

    par_area = cal_par_area(verts, faces);

    % ind = find(par_area>pi);
    % faces(ind,:)
    % path = ''; name = ''; needtosave = 0;
    % gen_view('disp_outline',verts,faces(ind,:),path,name,needtosave);
    % gen_view('disp_outline',verts,faces,path,name,needtosave);

    par_area = par_area / (4 * pi);

    obj_fun = sum((obj_area - par_area).^2);

    return;
