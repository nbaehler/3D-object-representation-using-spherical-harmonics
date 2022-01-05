% ============================================
% do_pca.m
%
% Principle Component Analysis
%   Points are transformed by translation (zero-mean) and dimension-reduced-rotation
%
% Li Shen 
% 07/12/2002 - create

function [pca_ps, pca_b, var_amt, latent] = do_pca(points,pca_dim)

% Reduce the number of eigenvectors to be N-c (subjects minus classes).
% Then project onto the new basis, i.e. calculate the dot product of each existing
% subject vector with each of the eigenvectors.
% N = n1 + n2;
% [pca_ps, pca_b] = newbasis(points, 'npca', pca_dim); % THERE ARE PROBLEMS PROBABLY???

% [points pointsavg] = zeromean(points);

pca_dim = min(pca_dim,size(points,2));
[pca_b, score, latent, tsquare] = princomp(points);
pca_b = pca_b(:,1:pca_dim);
pca_ps = points*pca_b;
var_amt = sum(latent(1:pca_dim))/sum(latent);
neg_ev_ind = find(latent<0);
if (~isempty(neg_ev_ind))
    disp(['Negative eigenvalues:', sprintf(' %f',latent(neg_ev_ind))]);
end 
latent = latent(1:pca_dim);

% disp(sprintf('points (%d %d) => pca_ps (%d %d)',size(points),size(pca_ps)))

return;
