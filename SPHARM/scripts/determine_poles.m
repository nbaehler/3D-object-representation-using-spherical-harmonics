function poles = determine_poles(vertices)
% use PCA to determine north pole (big z) and south pole (small z)
%


pca_dim = 3;
[pca_ps, pca_b, var_amt, latent] = do_pca(vertices,pca_dim);

pc1v = pca_ps(:,1); % first PC value
min_i = find(pc1v==min(pc1v)); n = length(min_i);
max_i = find(pc1v==max(pc1v))'; m = length(max_i);
disp(sprintf('after pca min_max_number: %d %d',n,m));

% pick the pair which is the furthest away from each other
min_i = min_i(:,ones(1,m));
max_i = max_i(ones(1,n),:);
dist = sum((vertices(min_i(:),:) - vertices(max_i(:),:)).^2,2);
[maxd, maxdi] = max(dist); % pick the max distance
min_i = min_i(maxdi); max_i = max_i(maxdi);

if vertices(min_i,3) > vertices(max_i,3)
    poles = [min_i max_i];
else
    poles = [max_i min_i];
end

return;
