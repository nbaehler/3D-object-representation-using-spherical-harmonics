function [verts, mstch] = smooth(verts, faces, info, obj_areas, tmajor)
    % smooth spherical mesh defined by verts and faces
    %

    meshsize = info(1); shd = info(2); tole = info(3); smft = info(4);

    % in fact, this is the area scaling ratio
    org_areas = cal_par_area(verts, faces) ./ obj_areas;

    % smooth areas a little bit
    areas = org_areas.^(1 / smft);

    % deal with negative areas and super large areas (not done yet)
    ind = find(areas <= 0);

    if ~isempty(ind)
        disp([sprintf('!!! === !!! %d bad relative areas:', length(ind)) sprintf(' %f', areas(ind))]);
    end

    % find the center of each face, assign radius for it (using area of the face)
    cents = (verts(faces(:, 1), :) + verts(faces(:, 2), :) + verts(faces(:, 3), :)) / 3;
    % create spharm descriptor for a shape drived from centers plus their radiuses
    d = shd; [fvec, d, Z] = spharm_vec(areas, cents, d);
    ind = 1:(d + 1)^2; radius = real(Z(:, ind) * fvec(ind)); radius = radius.^smft;

    [ma, ma_ind] = max(abs(log(radius)));
    ma_ind = ma_ind(1); ma_cent = mean(verts(faces(ma_ind, :), :));
    [theta, phi] = cart2sph(ma_cent(1), ma_cent(2), ma_cent(3));

    % disp(sprintf('pole %d area %f cent %f %f %f theta %f phi %f',ma_ind, ma, ma_cent,theta,phi));
    Ra = rotate_mat_xyz(0, 0, theta) * rotate_mat_xyz(0, pi / 2 - phi, 0); % rotate
    Rb = rotate_mat_xyz(0, -pi / 2 + phi, 0) * rotate_mat_xyz(0, 0, -theta); % rotate back

    verts = verts * Ra;

    % view_face_on_surface(verts, faces, ma_ind);

    % find the center of each face, assign radius for it (using area of the face)
    cents = (verts(faces(:, 1), :) + verts(faces(:, 2), :) + verts(faces(:, 3), :)) / 3;
    % create spharm descriptor for a shape drived from centers plus their radiuses
    d = shd; [fvec, d, Z] = spharm_vec(areas, cents, d);

    % create mesh for interpolation
    gsize = 2 / meshsize; ti = -1:(gsize / 2):1; n = length(ti);
    % spharm parameter convention (THETAs 0-pi, PHIs 0-2pi)
    [THETAs, PHIs] = meshgrid(ti, ti * pi); THETAs = asin(THETAs) + pi / 2; PHIs = PHIs + pi;

    % each grid consists of 4 grids generated before so that the centroid can be easily located
    gind = 2:2:length(ti); % length(ti) should be an odd number (grid is indexed by its center)
    gTHTs = THETAs(gind, gind); gPHIs = PHIs(gind, gind);
    Zm = spharm_basis(d, gTHTs(:), gPHIs(:));
    garea = real(Zm(:, ind) * fvec(ind)); garea = reshape(garea, size(gTHTs)); garea = garea.^smft;

    % get each grid height: gheight*garea=1
    gheight = ones(size(garea)) ./ garea;
    gmin = min(gheight(:)); bigind = find(gheight > gmin * tole); gheight(bigind) = gmin * tole;
    disp(sprintf('Adjust %d big values to %d * %f (gmin) = %f', length(bigind), tole, gmin, gmin * tole));

    % prepare for interpolation
    mind = 1:2:length(ti); X = THETAs(mind, mind); Y = PHIs(mind, mind);
    gheight_0 = zeros(size(gheight) + 1);
    gheight_0(2:end, 2:end) = gheight; gheight = gheight_0;

    switch tmajor
        case 0
            % try y major
            tt = sum(gheight(:));
            pvals = cumsum(sum(gheight, 2)) / sum(gheight(:)); pvals = pvals(:, ones(1, length(pvals)));
            lucumsum = cumsum(cumsum(gheight, 2), 1) / tt;
            tvals = zeros(size(lucumsum)); nzind = find(pvals ~= 0);
            tvals(nzind) = lucumsum(nzind) ./ pvals(nzind);
            tvals(1, :) = tvals(2, :);
            pvals = pvals * 2 * pi; % tvals need to be adjusted
            tvals = real(asin(tvals * 2 - 1)) + pi / 2; % tvals need to be adjusted
        case 1
            % x major
            tt = sum(gheight(:));
            tvals = cumsum(sum(gheight, 1)) / tt; tvals = tvals(ones(1, length(tvals)), :);
            lucumsum = cumsum(cumsum(gheight, 1), 2) / tt;
            pvals = zeros(size(lucumsum)); nzind = find(tvals ~= 0);
            pvals(nzind) = lucumsum(nzind) ./ tvals(nzind);
            pvals(:, 1) = pvals(:, 2); pvals = (pvals - 0.5) * pi * 2;
            tvals = real(asin(tvals * 2 - 1)) + pi / 2; % tvals need to be adjusted
    end

    stretch = gheight(find(gheight ~= 0)); stretch = max(stretch, 1 ./ stretch); mstch = mean(stretch(:));
    titstr = sprintf('spharm stretch: mean %f std %f', mstch, std(stretch(:))); disp(titstr);

    % do interpolation for each vertices
    [ps, ts] = cart2sph(verts(:, 1), verts(:, 2), verts(:, 3));
    ts = pi / 2 - ts;
    in = find(ps < 0); ps(in) = ps(in) + 2 * pi;

    new_ts = interp2(X, Y, tvals, ts, ps);
    new_ps = ps;

    [verts(:, 1), verts(:, 2), verts(:, 3)] = sph2cart(new_ps, pi / 2 - new_ts, 1);

    verts = verts * Rb;

    return;
