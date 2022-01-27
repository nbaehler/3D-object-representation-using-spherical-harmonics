function [fvec, d, Z] = spharm_vec(vertices, sph_verts, max_d)
    % create spherical harmonic descriptor
    %

    [PHI, THETA] = cart2sph(sph_verts(:, 1), sph_verts(:, 2), sph_verts(:, 3));
    ind = find(PHI < 0);
    PHI(ind) = PHI(ind) + 2 * pi;
    THETA = pi / 2 - THETA; % theta is taken as the polar (colatitudinal) coordinate with theta \in [0,pi]
    vertnum = length(THETA);

    % Note that degree 'd' we want to use depends on the vertnum
    % The total number of unknowns is (d+1)*(d+1)
    % The total number of equations is vertnum
    % We want equ_num >= unk_num
    d = max(1, floor(sqrt(vertnum) * 1/2));
    d = min(d, max_d);
    % disp(sprintf('Use spharm up to %d degree (vec_len=%d).',d,(d+1)^2));

    Z = spharm_basis(d, THETA, PHI);

    [x, y] = size(Z);
    disp(sprintf('Least square for %d equations and %d unknowns', x, y));

    fvec = Z \ vertices;

    return;
