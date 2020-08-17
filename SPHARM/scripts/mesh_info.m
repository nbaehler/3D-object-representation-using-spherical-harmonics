function [area_cost, angle_cost, cst_cost, obfn] = mesh_info(vs,faces)
% collect information about mesh
%

vnum = size(vs,1);
fnum = size(faces,1);
[area_cst, angle_cst, bad_angles] = get_cst(vs,faces);

epsiron = 0.0001;

angle_cost = length(bad_angles);
area_cost = area_cst'*area_cst;
cst = [area_cst(1:end-1); angle_cst];
cst_cost = cst'*cst;

obfn = obj_fun(vs);

disp(sprintf('OBJ %2.2f; ANGLE >pi %d; AREA %2.2f >2pi %d/%d bad %d cost %d; CST %d', ...
              obfn, angle_cost, sum(area_cst)+4*pi, ...
              length(find(area_cst+4*pi/fnum>2*pi)), length(area_cst), ...
              length(find(abs(area_cst)>epsiron)), area_cost, cst_cost));        
return;

