function disp_spharm_desc(fvec,meshsize,dg,path,name,needtosave)
% display surface based on spherical harmonic descriptor
% show 3 center great circles if meshsize == 2^k
%

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

% sph11_can_basis(meshsize, degree, fast)
% if need gc, set (fast~=1)
[Z, fs] = sph11_can_basis(meshsize, dg(2), 0);

lb = dg(1)^2+1;
ub = (dg(2)+1)^2;

vs = Z(:,lb:ub)*fvec(lb:ub,:);

vertices = real(vs); faces = fs;

h = figure;
hold on;
patches = patch('faces', faces, 'vertices', vertices, ...
		'FaceVertexCData', ones(size(vertices,1),1)*[0.8 0.8 0.8], ...
		'FaceColor', 'interp', 'EdgeColor', 'none');

% light('position', [1 0 0]); light('position', [-1 0 0]);
% light('position', [0 1 0]); light('position', [0 -1 0]);

l1 = light('position', [-1 -1 .1], 'color', [.3 .3 .3]);
l2 = light('position', [1 -1 .1], 'color', [.3 .3 .3]);
l3 = light('position', [-.5 1 .1], 'color', [.3 .3 .3]);
l4 = light;

material([.3 .4 .2 10]);
lighting phong;

hold off;

axis equal;
box on;
xlabel('x');
ylabel('y');
zlabel('z');
view(37.5, 15);
title(strrep(name,'_','-'));

% if (needtosave)
%     saveas(h,fullfile(path, sprintf('%s_olfc', name)), 'png');
%     close(h);
% end

return;
