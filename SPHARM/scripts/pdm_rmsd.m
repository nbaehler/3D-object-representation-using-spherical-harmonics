function rmsd = pdm_rmsd(fvec1, fvec2, res)
% Root-Mean_Square_Distance between two SPHARM surfaces using sampling.
%
%		fvec1 & fvec2 are spherical harmonic models for the two surfaces to
%			be compared
%		res is meshsize to use for reconstruction
%		rmds is the root mean square distance between the two surfaces
%		
%		This function assumes that the two surfaces and their underlying 
%		spherical harmonic functions have been registered to
%		one another.
%

vn = size(fvec1,1);
max_d = sqrt(vn)-1;

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
