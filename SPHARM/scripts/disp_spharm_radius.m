function disp_spharm_radius(fvec, meshsize, dg, path, name, needtosave)
    % display surface based on spherical harmonic descriptor
    % show 3 center great circles if meshsize == 2^k
    %

    % function disp_spharm_desc(fvec,meshsize,degree,lines)

    % adjust degree based on fvec
    max_d = sqrt(size(fvec, 1)) - 1;

    if (dg(1) < 0 | dg(2) > max_d)
        odg = dg;
        dg(1) = max(dg(1), 0);
        dg(2) = min(dg(2), max_d);
        disp(sprintf('degree [%d %d] adjusted to the possible range [%d %d]', odg, dg));
    else
        disp(sprintf('degree [%d %d]', dg));
    end

    % sph11_can_basis(meshsize, degree, fast)
    % if need gc, set (fast~=1)
    [Z, fs, theta, phi] = sph11_can_basis(meshsize, dg(2), 0);

    lb = dg(1)^2 + 1;
    ub = (dg(2) + 1)^2;

    radius = real(Z(:, lb:ub) * fvec(lb:ub, :));
    [vs(:, 1), vs(:, 2), vs(:, 3)] = sph2cart(theta, phi, radius);

    gen_view('disp_face_edge', vs, fs, path, name, needtosave);

    return;
