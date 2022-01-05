function [vertices, newfaces]=make_spharm_model_surface(fvec,meshsize,dg)
% makes surface from spherical harmonic model fvec
%

% adjust degree based on fvec
max_d = sqrt(size(fvec,1))-1;
if (dg(1)<0 || dg(2)>max_d)
    odg = dg;
    dg(1) = max(dg(1),0);
    dg(2) = min(dg(2),max_d);
    disp(sprintf('degree [%d %d] adjusted to the possible range [%d %d]', odg, dg));
else
    disp(sprintf('degree [%d %d]', dg));
end

% sph11_can_basis(meshsize, degree, fast)
% if need gc, set (fast~=1)
[Z, fs] = sph11_can_basis(meshsize, dg(2), 0);

lb = dg(1)^2+1;
ub = (dg(2)+1)^2;

vs = Z(:,lb:ub)*fvec(lb:ub,:);

vertices = real(vs); faces = fs;

% Convert faces matrix, which now are squares into triangles.
[rowsfaces, colsfaces] = size(faces);
newfaces = zeros((rowsfaces*2),3);
for i=1:rowsfaces
	newrow = (i*2)-1;
	newfaces(newrow,1) = faces(i,1);
	newfaces(newrow,2) = faces(i,2);
	newfaces(newrow,3) = faces(i,3);
	newrow = newrow + 1;
	newfaces(newrow,1) = faces(i,1);
	newfaces(newrow,2) = faces(i,3);
	newfaces(newrow,3) = faces(i,4);
end

return;
