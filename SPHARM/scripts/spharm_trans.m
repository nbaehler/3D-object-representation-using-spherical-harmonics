% spharm_trans.m
% 
% Goal: apply 4*4 transformation matrix 1_2_RM.mat to 
%       vertices and fvec in 1_des.mat
% 
% 06/19/2007 - Create by Joshua C.H.Lu
% 07/14/2007 - Modified by Li Shen

function spharm_trans

% version information
ver = version;
if str2num(ver(1)) >=7
    vstr = '-v6';
else
    x = 1; vstr = 'x';       
end

files = {...
'1GL8model1e15_40_0_des.mat', '1gl8_1uvz_RM.mat';
'1GL8model1e15_40_0_des.mat', '1gl8_1xfl_RM.mat';
'1GL8model1e15_40_0_des.mat', '1gl8_1xoa_RM.mat';
'1GL8model1e15_40_0_des.mat', '1gl8_1xw9_RM.mat';
'1UVZchainAnoh2oe15_40_0_des.mat', '1uvz_1xfl_RM.mat';
'1UVZchainAnoh2oe15_40_0_des.mat', '1uvz_1xoa_RM.mat';
'1UVZchainAnoh2oe15_40_0_des.mat', '1uvz_1xw9_RM.mat';
'1XFLmodel1e15_40_0_des.mat', '1xfl_1xoa_RM.mat';
'1XFLmodel1e15_40_0_des.mat', '1xfl_1xw9_RM.mat';
'1XOAmodel1e15_40_0_des.mat', '1xoa_1xw9_RM.mat'
}

for i=1:size(files,1)
    spharm_file = files{i,1};
    matrix_file = files{i,2};
    apply_trans(spharm_file, matrix_file, vstr);
end

return;

%
% apply transformation
%

function apply_trans(spharm_file, matrix_file, vstr)
load(spharm_file);
load(matrix_file);

dg = [0 12]; meshsize = -3;

Y00 = sqrt(1/pi)/2; % Y00 is the spherical harmonic of degree 0 and order 0

% x = real(fvec(1,:)*Y00);

R = M(1:3,1:3)';
T = M(1:3,4)';

figure;
subplot(2,3,1);
patch_shademesh(vertices,faces);

subplot(2,3,2);
vertices = vertices*R;
patch_shademesh(vertices,faces);

subplot(2,3,3);
% verts = vertices; verts(:,4) = 1; verts = verts * M'; verts = verts(:,1:3);
vertices = vertices + T(ones(1,size(vertices,1)),:);
patch_shademesh(vertices,faces);

subplot(2,3,4);
[vs, fs] = surf_spharm(fvec,dg,meshsize);
patch_shademesh(vs,fs);

subplot(2,3,5);
fvec = fvec*R;
[vs, fs] = surf_spharm(fvec,dg,meshsize);
patch_shademesh(vs,fs);

subplot(2,3,6);
fvec(1,:) = fvec(1,:) + T/Y00;
[vs, fs] = surf_spharm(fvec,dg,meshsize);
patch_shademesh(vs,fs);

fname = sprintf('a2_%s_%s',matrix_file(6:9),spharm_file)
save(fname,'dateline','faces','fvec','landmarks','neighbours','smo_cost','sph_verts','vertices',vstr);

return;
% 
% return;
% 
% 
% %
% % calculate the spherical harmonic functions
% % do not use 'i'
% %
% 
% function Z = spharm_basis(max_degree,theta,phi)
% 
% Z = []; vnum = length(theta);
% 
% % save calculations for efficiency
% for k = 0:(2*max_degree)
%     fact(k+1) = factorial(k);
% end
% for m = 0:max_degree
%     exp_i_m_phi(:,m+1) = exp(i*m*phi);
%     sign_m(m+1) = (-1)^(m);
% end
% 
% for n = 0:max_degree
% 
% 	% P = legendre(n,X) computes the associated Legendre functions of degree n and 
% 	% order m = 0,1,...,n, evaluated at X. Argument n must be a scalar integer 
% 	% less than 256, and X must contain real values in the domain -1<=x<=1.
% 	% The returned array P has one more dimension than X, and each element
% 	% P(m+1,d1,d2...) contains the associated Legendre function of degree n and order
% 	% m evaluated at X(d1,d2...).
% 
%     Pn = legendre(n,cos(theta'))';
%     
%     posi_Y = [];
%     nega_Y = [];
%     
%     m= 0:n;
%     v = sqrt(((2*n+1)/(4*pi))*(fact(n-m+1)./fact(n+m+1)));
%     v = v(ones(1,vnum),:).*Pn(:,m+1).*exp_i_m_phi(:,m+1);
%     posi_Y(:,m+1) = v; % positive order;
%     nega_Y(:,n-m+1) = sign_m(ones(1,vnum),m+1).*conj(v); % negative order
%     
%     Z(:,end+1:end+n) = nega_Y(:,1:n);
%     Z(:,end+1:end+n+1) = posi_Y(:,1:(n+1));
% end
% 
% return;
