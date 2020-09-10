function show_asr(verts,faces,info,obj_areas,xymajor)
% visualize asr function
%

% [verts,faces] = extend_flat_net(verts,faces);

meshsize = info(1); shd = info(2); tole = info(3);

% fnum = size(faces,1);
% [area_cst, angle_cst, bad_angles] = get_cst(verts,faces);
% areas = area_cst + 4*pi/fnum;

areas = cal_par_area(verts,faces)./obj_areas;

% deal with negative areas and super large areas (not done yet)
ind = find(areas<=0);
if ~isempty(ind)
    disp([sprintf('%d bad relative areas:',length(ind)) sprintf(' %f',areas(ind))]);
end

% find the center of each face, assign radius for it (using area of the face)
cents = (verts(faces(:,1),:) + verts(faces(:,2),:) + verts(faces(:,3),:))/3;
% create spharm descriptor for a shape drived from centers plus their radiuses
d = shd; [fvec,d,Z] = spharm_vec(areas, cents, d);
ind = 1:(d+1)^2; radius = real(Z(:,ind)*fvec(ind));

% rotate parameter net so that the minimum area moves to the north pole
% [ma, ma_ind] = min(radius);
[ma, ma_ind] = max(radius);
ma_ind = ma_ind(1); ma_cent = cents(ma_ind,:);
[theta,phi] = cart2sph(ma_cent(1), ma_cent(2), ma_cent(3));
disp(sprintf('pole %d area %f cent %f %f %f theta %f phi %f',ma_ind, ma, ma_cent,theta,phi));
Ra = rotate_mat_xyz(0, 0, theta)*rotate_mat_xyz(0, pi/2-phi, 0);
Rb = rotate_mat_xyz(0, -pi/2+phi, 0)*rotate_mat_xyz(0, 0, -theta);

verts = verts*Ra; 

% view_face_on_surface(verts, faces, ma_ind);

% find the center of each face, assign radius for it (using area of the face)
cents = (verts(faces(:,1),:) + verts(faces(:,2),:) + verts(faces(:,3),:))/3;
% create spharm descriptor for a shape drived from centers plus their radiuses
d = shd; [fvec,d,Z] = spharm_vec(areas, cents, d);
ind = 1:(d+1)^2; radius = real(Z(:,ind)*fvec(ind));

% create mesh for interpolation
gsize = 2/meshsize; %gsize = .1; 
ti = -1:(gsize/2):1; n = length(ti);
% spharm parameter convention (THETAs 0-pi, PHIs 0-2pi)
[THETAs,PHIs] = meshgrid(ti,ti*pi);
THETAs = asin(THETAs)+pi/2; PHIs = PHIs+pi;
% figure; surf(THETAs,PHIs,ones(size(THETAs))); return;
Z = spharm_basis(d,THETAs(:),PHIs(:));
RADIUS = real(Z(:,ind)*fvec(ind)); RADIUS = reshape(RADIUS,size(THETAs));
% radius should be >0 (MORE INVESTIGATION!!!)
minval = 10^(-10); smlind = find(RADIUS<minval); 
disp(sprintf('%d negative radiuses',length(smlind))); RADIUS(smlind)=minval;
%figure; plot3(THETAs,PHIs,RADIUS,'.'); return;

% each grid consists of 4 grids generated before so that the centroid can be easily located
gind = 2:2:length(ti); % length(ti) should be an odd number (grid is indexed by its center)
gcents = RADIUS(gind,gind); % grid center value
% garea = 1/length(gind)^2; % same for all

% get each grid volumes
%gvols = gcents*garea;
gvols = ones(size(gcents))./gcents;
gmin = min(gvols(:)); bigind = find(gvols>gmin*tole); gvols(bigind) = gmin*tole;
disp(sprintf('Adjust %d big values to %d * %f (gmin) = %f',length(bigind),tole,gmin,gmin*tole));

% disp(sprintf('max %f, min %f, mean %f, std %f', max(gvols(:)), min(gvols(:)), mean(gvols(:)), std(gvols(:))));
gvols = gvols/sum(sum(gvols));
disp(sprintf('volume sum: %d',sum(sum(gvols))));

% prepare for interpolation
mind = 1:2:length(ti);
X = THETAs(mind,mind); Y = PHIs(mind,mind);
gvols_0 = zeros(size(gvols)+1);
gvols_0(2:end,2:end) = gvols; gvols = gvols_0;
lucumsum = cumsum(cumsum(gvols,1),2);

figure; hold on; mesh(X,Y,gvols); xlabel('theta'); ylabel('phi'); 
title(sprintf('mean %d std %d',mean(gvols(:)),std(gvols(:)))); hold off; a = axis; view(3);
% figure; hold on; mesh(X,Y,pvals); mesh(X,Y,tvals); xlabel('theta'); ylabel('phi'); hold off; axis(a); view(3);

return;

