function verts = latitude_smooth(verts,faces,obj_area,iter);
% smooth latitude a little bit
%

obj_fun = cal_obj_fun(verts, faces, obj_area);
best_cost = obj_fun;
for i=1:iter
    [theta, phi] = cart2sph(verts(:,1),verts(:,2),verts(:,3)); 
    
    phi = sin(phi)*pi/2;
    [new_verts(:,1),new_verts(:,2),new_verts(:,3)] = sph2cart(theta, phi, 1);
    obj_fun = cal_obj_fun(new_verts, faces, obj_area);
    if obj_fun > best_cost
        return;
    end
    best_cost = obj_fun; verts = new_verts;
    gen_view('disp_outline', verts, faces, '', sprintf('%dth latitude smoothing: %f',i,obj_fun), 0);
end

return;

