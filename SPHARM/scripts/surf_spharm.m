% ============================================
% surf_spharm.m
%
% purpose: generate surface data structure based on spharm
%
% Li Shen
% 12/29/2006 - create

function [vs, fs] = surf_spharm(fvec,dg,meshsize);

vs = []; fs = []; gc = [];

if isempty(fvec)
    return;
end

% adjust degree based on fvec
max_d = sqrt(size(fvec,1))-1;
if (dg(1)<0 | dg(2)>max_d)
    odg = dg;
    dg(1) = max(dg(1),0);
    dg(2) = min(dg(2),max_d);
    disp(sprintf('degree [%d %d] adjusted to the possible range [%d %d]', odg, dg));
else
    disp(sprintf('degree [%d %d]', dg));
end

% % sph11_can_basis(meshsize, degree, fast)
% % if need gc, set (fast~=1)
% [Z, fs] = sph11_can_basis(meshsize, dg(2), 0);

if length(meshsize)==1
    res = meshsize;
    [vs, fs] = mo11b_sampling(res);
else
    vs = meshsize{1}; fs = meshsize{2};
end
Z = mo11c_basis(vs, dg(2));

lb = dg(1)^2+1;
ub = (dg(2)+1)^2;

vs = Z(:,lb:ub)*fvec(lb:ub,:); 
vs = real(vs);
    
return;
