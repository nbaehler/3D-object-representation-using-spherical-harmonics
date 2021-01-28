function [nfvec, rotatedVertices, rotatedLandmarks] = spharm_align(path, process_file, template_file)
% SPHARM_align
%
% Goal: Align two SPHARM models in object and parameter spaces
%       Use landmark in object space
%       Use SHREC algorithm in parameter space
%
% Li Shen 
% 07/16/2007 - create
%	Modified by Mark McPeek 07/18/07
%   & 6 October 2013 modified to return transformed vertices and landmarks.

% Get information from template object
% The file listed here must be the exact name of the template file.
load(template_file); 
tfvec = fvec; 
tvertices = vertices; 
tfaces = faces;
tldmk = landmarks;

% read and process images
[fakepath, name, ext] = fileparts(process_file);
load(fullfile(path, process_file));
ldmk = landmarks;

% use landmarks to do alignment in the object space
P = ldmk; X = tldmk;
% 	figure;
% 	subplot(1,2,1); hold on;
% 	plot3(X(:,1),X(:,2),X(:,3),'b.', P(:,1),P(:,2),P(:,3),'r.','MarkerSize',20);
%	patch_mesh(tvertices, tfaces);
%	patch_lighta(vertices, faces);
% 	axis equal; box on; title('before alignment');
%	hold off;
    
[Pnew,M] = cps_align(ldmk,tldmk);
% Modified by Mark A. McPeek, 6 October 2013 to apply transformation to
% vertices and landmarks as well and return them to calling function.
% Previously, the transformation was applied only to fvec, and so only the
% fvec in the registered surface was in the correct coordinate system.
% [vertices, fvec] = apply_trans(vertices, faces, fvec, M);  % old function call
[rotatedVertices, rotatedLandmarks, fvec] = apply_trans(vertices, faces, landmarks, fvec, M);
    
% 	subplot(1,2,2); hold on;
% 	plot3(X(:,1),X(:,2),X(:,3),'b.', Pnew(:,1),Pnew(:,2),Pnew(:,3),'r.','MarkerSize',20);
%	patch_mesh(tvertices, tfaces);
%	patch_lighta(vertices, faces);
% 	axis equal; box on; title('alignment in object space');
%	hold off;
    
% 	new_name = sprintf('%sregTOldmks',name(1:end-3));
% 	save(fullfile(path,new_name),  'fvec', 'sph_verts', 'vertices', 'faces', 'dg');

% after objects are aligned in the object space, align in parameter
% space to establish surface correspondence
% Mark McPeek changed this to return nfvec from param_align. 18 July 2007
%	It didn't seem that it was writing the correct fvec to the file.
%	It looked like the old fvec was being written to the file.
[nfvec] = param_align(tfvec, fvec, 'template', name);
    
% new_name = sprintf('%sreg',name(1:end-3));
% save(fullfile(path,new_name),  'nfvec', 'sph_verts', 'vertices', 'faces', 'landmarks', 'dg');
% 
return;


%=======================================================================%
function [vertices, landmarks, fvec] = apply_trans(vertices, faces, landmarks, fvec, M)
% apply 4*4 transformation matrix M to vertices and fvec
%  This function modified by Mark McPeek, 6 October 2013 to apply
%  transformation to landmarks as well.

R = M(1:3,1:3)';
T = M(1:3,4)';

Y00 = sqrt(1/pi)/2; % Y00 is the spherical harmonic of degree 0 and order 0
fvec = fvec*R;
fvec(1,:) = fvec(1,:) + T/Y00;

% transform vertices
vertices = vertices*R;
vertices = vertices + T(ones(1,size(vertices,1)),:);
% verts = vertices; verts(:,4) = 1; verts = verts * M'; verts = verts(:,1:3);

% transform landmarks
landmarks = landmarks*R;
landmarks = landmarks + T(ones(1,size(landmarks,1)),:);

return;


%=======================================================================%
function [fvec] = param_align(atlas,fvec,atname,name)
% Use SHREC algorithm to align SPHARM model in parameter space
%

global fact;
global sgm;

utl_sgm(35);

% factorial(170) = Inf
for i=0:170 
    fact(i+1) = factorial(i);
end

% m01-gran-100-hippo-d15
% inform = spm_input('degrees(2) meshsize gran scale', '+0', 's', '0 15 32 100 0'); 
inform = '0 15 32 100 0'; 
info = str2num(inform); dg = info(1:2); meshsize = info(3); 
gran = info(4); % gran = # of alphas to process together
scale = info(5); % make rmsd scaling invariant
% inform = spm_input('base_res step depth top_n', '+0', 's', '1 1 3 1'); % hierarchy
% inform = spm_input('base_res step depth top_n', '+0', 's', '1 0 0 1'); % no hierarchy
% inform = spm_input('base_res step depth top_n', '+0', 's', '2 2 1 1'); % base mesh at depth 0
% inform = spm_input('base_res step depth top_n', '+0', 's', '4 0 0 1'); % base mesh at depth 0
inform = '1 1 3 1';
res = str2num(inform); % base res R + step of hierarchy Hs + depth of hierarchy Hd + top N 

% create samples in rotation space
% [alpha, beta, gamma] = euler_angle(3,1); return;
[alpha, beta, gamma, samples] = euler_angle_hie(res); % euler_angle hierarchy

t = cputime;

% % read and process images
% n = size(files,1);
% spm_progress_bar('Init',n,'Reading objects','objects completed');
% for i=1:size(files,1)

%     % the first object is the atlas
% 	subfile = deblank(files{i,1});
% 	[path,name,ext,ver] = fileparts(subfile);
% 	load(subfile); fvec = fixed_fvec(fvec,dg(2),scale);
% 	atlas = fvec; atname = name;

    atlas = fixed_fvec(atlas,dg(2),scale);
	
	Aprm = [0 0 0]; % angles for registration parameterization
	Robj = eye(4); % rotation matrix for alignment in object space, homogeneous coordinates

%     subfile = deblank(files{i,2});
%     [path,name,ext,ver] = fileparts(subfile);
%     load(subfile); [fvec, max_d] = fixed_fvec(fvec,dg(2),scale);
%     disp(sprintf('\n========= Processing %s =========',name));

    [fvec, max_d] = fixed_fvec(fvec,dg(2),scale);

    rmsd(1) = SPHARM_rmsd(fvec, atlas);
%     rmsd(1) = PDM_rmsd(fvec, atlas, -3); % for debug purpose
    
% 	h = figure; set(gcf,'PaperPositionMode','auto');
% 	set(h,'DefaultAxesFontSize',5); 
% 	set(h,'DefaultAxesXtick',[]);
% 	set(h,'DefaultAxesYtick',[]);
% 	set(h,'DefaultAxesZtick',[]);    
%     subplot(1,3,1);
%     disp_spharm_desc(atlas,meshsize,dg,path,atname,[],0);
%     zlabel('template'); xlabel(''); ylabel('');
%     subplot(1,3,2);
%     disp_spharm_desc(fvec,meshsize,dg,path,name,[],0);
%     zlabel(sprintf('rmsd = %f',rmsd(1))); xlabel(''); ylabel('');

    % assume aligned in object space, register the parameterization
    [fvec, Aprm] = match_param_hie(fvec,atlas,alpha,beta,gamma,gran,res,max_d);
    rmsd(2) = SPHARM_rmsd(fvec, atlas);
        
%     figure(h); subplot(1,3,3);
%     disp_spharm_desc(fvec,meshsize,dg,path,sprintf('rot: %1.2f, %1.2f, %1.2f',Aprm),[],0);
%     zlabel(sprintf('rmsd = %f',rmsd(2))); xlabel(''); ylabel('');
%     saveas(h,sprintf('%s_to_%s',name,atname),'png')
    
    disp(sprintf('Base Res %d, Step %d, Depth %d, Top %d: RMSD %f => %f',res,rmsd));
    
% seconds = cputime - t; hours = seconds/3600;
% disp(['seconds=', num2str(seconds), ' hours=', num2str(hours)]);
% disp(sprintf('%d samples',samples));

return;


%=======================================================================%
function disp_spharm_desc(fvec,meshsize,dg,path,name,lines,needtosave)
% function disp_spharm_desc(fvec,meshsize,degree,lines)
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
end

% % sph11_can_basis(meshsize, degree, fast)
% % if need gc, set (fast~=1)
% [Z, fs] = sph11_can_basis(meshsize, dg(2), 0);

res = meshsize;
[vs, fs] = mo11b_sampling(res);
Z = mo11c_basis(vs, dg(2));

lb = dg(1)^2+1;
ub = (dg(2)+1)^2;

vs = real(Z(:,lb:ub)*fvec(lb:ub,:));

patch_shademesh(vs, fs, lines);
% title(strrep(name,'_','-')); 
box off;

return;


%=======================================================================%
function [best_fvec, best_angl] = match_param_hie(fvec,atlas,A,B,G,gran,res,max_d)
% match fvec to atlas by rotating the parameterization of fvec
% - object does not transform in the object space
% - alpha, beta, gamma: samples in the rotation space
% - gran = # of alphas to process together
% - res: base res R + step of hierarchy Hs + depth of hierarchy Hd + top N 
%

% base resolution R, step of hierarchy Hs, depth of hierarchy Hd, top N 
R = res(1); Hs = res(2); Hd = res(3); N = res(4);
disp(sprintf('----- Base Res %d, Step %d, Depth %d -----',R,Hs,Hd));
alpha = A{1}; beta = B{1}; gamma = G{1};
[fvec, Aprm] = match_param(fvec,atlas,alpha,beta,gamma,gran,N,max_d); 
fvec = fvec(:,:,1); Aprm = Aprm(1,:); % remove later on
best_angl = Aprm;
for i=1:Hd
    disp(sprintf('----- Res %d -----',R+Hs*i));
    alpha = A{i+1}; beta = B{i+1}; gamma = G{i+1};
    [fvec, Aprm] = match_param(fvec,atlas,alpha,beta,gamma,gran,1,max_d);
    best_angl(i+1,:) = Aprm;
end
best_fvec = fvec;
    
return;

%

%=======================================================================%
function [best_fvec, best_angl] = match_param(fvec,atlas,alpha,beta,gamma,gran,N,max_d)
% match fvec to atlas by rotating the parameterization of fvec
% - object does not transform in the object space
% - alpha, beta, gamma: samples in the rotation space
% - gran = # of alphas to process together
% - N: keep top N results
%

best_fvec = fvec; best_fvec = best_fvec(:,:,ones(1,N));
best_rmsd = ones(1,N)*SPHARM_rmsd(fvec, atlas);
best_angl = zeros(N,3);

% find best correspondence by rotating parameterization
n = length(alpha); m = length(gamma); nm = n*m;
alpha = alpha(:,ones(1,m)); beta = beta(:,ones(1,m)); gamma = gamma(ones(1,n),:);
xx = ceil(nm/gran); bd = [0 (1:xx)*gran]; bd(end) = nm;    
for k = 1:xx
    idx = (bd(k)+1):bd(k+1); g = length(idx);
    [rvec] = rotate_param_m03(alpha(idx)', beta(idx)', gamma(idx)', fvec, max_d); % m03 < m02 < m01 < s03 < s01 < s00
    rmsd = SPHARM_rmsd_batch(rvec, atlas);
    best_rmsd = [best_rmsd rmsd];
    best_fvec(:,:,end+(1:g)) = rvec;
    best_angl(end+(1:g),:) = [alpha(idx)', beta(idx)', gamma(idx)'];
    [best_rmsd,ind] = sort(best_rmsd); best_rmsd = best_rmsd(1:N); ind = ind(1:N);
    best_fvec = best_fvec(:,:,ind);
    best_angl = best_angl(ind,:);
    disp([sprintf('(%d/%d) RMSD = %f, BEST =',bd(k)+j,nm,rmsd(end)), sprintf(' %f',best_rmsd)]);
end
    
return;

%

%=======================================================================%
function [A, B, G, samples] = euler_angle_hie(res)
% hierarchy of euler angle samples in the rotation space
%

% base resolution R, step of hierarchy Hs, depth of hierarchy Hd 
R = res(1); Hs = res(2); Hd = res(3);
[alpha, beta, gamma] = euler_angle(R,0);
A{1} = alpha; B{1} = beta; G{1} = gamma;
samples = length(alpha)*length(gamma);
for i=1:Hd
    Rp = R;
    R = R + Hs;
    [alpha, beta, gamma] = euler_angle(R,Rp);
    A{i+1} = alpha; B{i+1} = beta; G{i+1} = gamma;
    samples = samples + length(alpha)*length(gamma);
end

return;


%=======================================================================%
function [alpha, beta, gamma] = euler_angle(res,pres)
% euler angle samples in the rotation space
%

% % number of vertices at different level of subdivision
% vnum = [42 162 642  2562 10242 40962 163842]
% fnum = [80 320 1280 5120 20480 81920 327680];
% vnum = fnum/2+2

% gamma is set up in the way that high resolution samples contain low
% resolution samples
fnum = 80*4.^(0:10); vnum = fnum/2+2; knum = round(3.5*2.^(0:10)); k = knum(res+1);

% gamma = 0:2*pi/k:pi; gamma = [-gamma(end:-1:2) gamma]; % [-pi, pi] at base level
% disp(abs(gamma(end)-gamma(1)-2*pi));
% if (abs(gamma(end)-gamma(1)-2*pi))<1.0000e-020
%     gamma = gamma(1:end-1);
% end

gamma = 0:2*pi/k:2*pi; gamma = gamma(1:end-1); % alpha could be any value that requires gamma to rotate it back

% disp(sprintf('%f ',gamma));

[vs, fs] = mo11b_sampling(-res);

if pres==0 % include all thetas
    theta = Inf;
else % keep only the top thetas
	pvs = vs(1:vnum(pres),:);
	[PHI,THETA] = cart2sph(pvs(:,1),pvs(:,2),pvs(:,3));
	THETA = pi/2-THETA;
	theta = min(THETA(2:end));
end

[PHI,THETA] = cart2sph(vs(:,1),vs(:,2),vs(:,3));
ind = find(PHI<0); PHI(ind) = PHI(ind)+2*pi;
THETA = pi/2-THETA;

idx = find(THETA<=theta);
THETA = THETA(idx);
PHI = PHI(idx);

% h = figure; 
% set(h,'DefaultPatchLineWidth',1);
% set(gcf,'PaperPositionMode','auto');
% hold on;
% patch_mesh(vs,fs);
% if pres~=0
%     plot3(vs(1:vnum(pres),1),vs(1:vnum(pres),2),vs(1:vnum(pres),3),'ro','MarkerSize',10,'LineWidth',2);
% end
% plot3(vs(idx,1),vs(idx,2),vs(idx,3),'b.','MarkerSize',20);
% hold off;
% print -zbuffer -depsc2 -tiff hierarchy.eps;

alpha = -PHI;
beta = -THETA;

disp(sprintf('%d*%d = %d samples in rotation space',length(alpha),k,k*length(alpha)));

return;


%=======================================================================%
function euler_visual(alpha,beta,gamma)
% visualize euler angle
%

[vs, fs] = mo11b_sampling(-3);

n = length(alpha);

figure;
for i=1:n
	R = rotmat(0, 0, -alpha(i))*rotmat(0, -beta(i), 0);
	ovs = (R*[0 0 1]')';
	subplot(1,n,i);
	patch_mesh(vs, fs); 
	hold on; plot3(ovs(1),ovs(2),ovs(3),'b*','MarkerSize',15,'LineWidth',2); hold off;
	xlabel('x'); ylabel('y'); zlabel('z'); view(140,25);
	title(sprintf('euler angle: %1.2f, %1.2f, %1.2f',alpha(i),beta(i),gamma(i)));
end

return;


%=======================================================================%
function [rvec, M] = match_icp(fvec,atlas,max_d);
% use icp to align object together first
%

dg = [0 max_d]; meshsize = -3;
[X, fs] = surf_spharm(atlas,dg,meshsize);
[P, fs] = surf_spharm(fvec,dg,meshsize);

% align P to X
[P,M] = align_icp(P,X);
rvec = (M(1:3,1:3)*fvec')';

% % you can fix translation as follows, 
% % but no need to do so, otherwise rmsd gets increased because of Y00-0>=0
% rvec(1,:) = M(1:3,4)'*2*sqrt(pi); % Y00 = 1/(2*sqrt(pi))
% [P1, fs] = surf_spharm(rvec,dg,meshsize);
% sum((P - P1).^2)

return;


%=======================================================================%
function [fvec, max_d] = fixed_fvec(fvec, max_d, scale)
% fix fvec
%

fvec(1,:) = 0;
len = (max_d+1)^2;
if size(fvec,1)>len
    fvec = fvec(1:len,:);
end
max_d = min(max_d,sqrt(size(fvec,1))-1);

if scale == 1
    [vs, fs] = surf_spharm(fvec,[1 max_d],-3);
    obsz = sqrt(sum(vs(:).^2)/size(vs,1)); % size measure
    fvec = fvec/obsz; % adjust size to be 1
    disp('Adjust size to be 1');
end
    
return;


%=======================================================================%
function rmsd = SPHARM_rmsd_batch(fvec1, fvec2)
% distance between two SPHARM surfaces
%

n = size(fvec1,3);
fvec2 = fvec2(:,:,ones(1,n));
dist = fvec1-fvec2;
dist(1,:,:) = 0; % remove the translation
[d(1),d(2),d(3)] = size(dist); 
dist = reshape(dist,d(1)*d(2),d(3));
rmsd = sum(abs(dist).^2).^(1/2)/sqrt(4*pi);

return;


%=======================================================================%
function rmsd = SPHARM_rmsd(fvec1, fvec2)
% distance between two SPHARM surfaces
%

dist = fvec1-fvec2;
dist(1,:) = 0; % remove the translation
% dist = [real(dist) imag(dist)]
rmsd = norm(dist(:))/sqrt(4*pi);

return;


%=======================================================================%
function rmsd = PDM_rmsd(fvec1, fvec2, res)
% distance between two SPHARM surfaces using sampling
%

vn = size(fvec1,1);
max_d = sqrt(vn)-1;

% res = -3
[vs, fs] = mo11b_sampling(res);
Z = mo11c_basis(vs, max_d);

vs1 = real(Z*fvec1);
vs2 = real(Z*fvec2);

% figure;
% subplot(1,3,1); patch_mesh(vs,fs);
% subplot(1,3,2); patch_mesh(vs1,fs);
% subplot(1,3,3); patch_mesh(vs2,fs);

rmsd = (vs1-vs2).^2;
rmsd = sqrt(sum(rmsd(:))/size(vs,1));

return;


%=======================================================================%
function R = rotmat(x, y, z)
% Rotate around x, y, z (counterclockwise when looking towards the origin)
%

Rx = [      1       0       0; ...
            0  cos(x) -sin(x); ...
            0  sin(x)  cos(x)];

Ry = [ cos(y)       0  sin(y); ...
            0       1       0; ...
      -sin(y)       0  cos(y)];

Rz = [ cos(z) -sin(z)       0; ...
       sin(z)  cos(z)       0; ...
            0      0        1];

R = Rz*Ry*Rx;

return;


%=======================================================================%
function [alpha, beta] = euler_angle_demo(res,i)
% sample euler angle (demo version)
%

[vs, fs] = mo11b_sampling(-res);

[PHI,THETA] = cart2sph(vs(:,1),vs(:,2),vs(:,3));
ind = find(PHI<0); PHI(ind) = PHI(ind)+2*pi;
THETA = pi/2-THETA;

alpha = -PHI;
beta = -THETA;

% alpha = pi/2-PHI;
% beta = THETA;

Z = mo11c_basis(vs, 1);
fvec = Z\vs;

h = figure; set(gcf,'PaperPositionMode','auto');
meshsize = 32; dg = [0 1];
subplot(1,3,1);
disp_spharm_desc(fvec,meshsize,dg,'','',[],0); 
hold on; plot3(vs(i,1),vs(i,2),vs(i,3),'r*','MarkerSize',15,'LineWidth',2); hold off;
xlabel('x'); ylabel('y'); zlabel('z'); view(140,25);

[rvec] = rotation_coe(alpha(i), 0, 0, fvec, 1);
subplot(1,3,2);
disp_spharm_desc(rvec,meshsize,dg,'','',[],0);
hold on; plot3(vs(i,1),vs(i,2),vs(i,3),'r*','MarkerSize',15,'LineWidth',2); hold off;
xlabel('x'); ylabel('y'); zlabel('z'); view(140,25);

[rvec] = rotation_coe(0, beta(i), 0, rvec, 1);
subplot(1,3,3);
disp_spharm_desc(rvec,meshsize,dg,'','',[],0);
hold on; plot3(vs(i,1),vs(i,2),vs(i,3),'r*','MarkerSize',15,'LineWidth',2); hold off;
xlabel('x'); ylabel('y'); zlabel('z'); view(140,25);

figure; set(gcf,'PaperPositionMode','auto');
subplot(1,3,1); patch_mesh(vs, fs); 
hold on; plot3(vs(i,1),vs(i,2),vs(i,3),'r*','MarkerSize',15,'LineWidth',2); hold off;
xlabel('x'); ylabel('y'); zlabel('z'); view(140,25);

R = rotmat(0, 0, alpha(i));
vs = (R*vs')';

subplot(1,3,2); patch_mesh(vs, fs); 
hold on; plot3(vs(i,1),vs(i,2),vs(i,3),'r*','MarkerSize',15,'LineWidth',2); hold off;
xlabel('x'); ylabel('y'); zlabel('z'); view(140,25);

R = rotmat(0, beta(i), 0);
vs = (R*vs')';

subplot(1,3,3); patch_mesh(vs, fs); 
hold on; plot3(vs(i,1),vs(i,2),vs(i,3),'r*','MarkerSize',15,'LineWidth',2); hold off;
xlabel('x'); ylabel('y'); zlabel('z'); view(140,25);

str = sprintf('theta=%f,phi=%f,alpha=%f,beta=%f',THETA(i),PHI(i),alpha(i),beta(i));
disp(str);

return;
