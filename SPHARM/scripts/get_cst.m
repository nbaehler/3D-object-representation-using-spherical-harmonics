function [area_cst, angle_cst, bad_angles] = get_cst(vs, faces)
    % Get constraints
    %

    fnum = size(faces, 1);
    d = size(vs);

    angles = [];

    for j = 1:4
        A = vs(faces(:, j), :);
        B = vs(faces(:, mod(j, 4) + 1), :);
        C = vs(faces(:, mod(j - 2, 4) + 1), :);
        y = A(:, 1) .* B(:, 2) .* C(:, 3) - A(:, 1) .* B(:, 3) .* C(:, 2) + ...
            A(:, 2) .* B(:, 3) .* C(:, 1) - A(:, 2) .* B(:, 1) .* C(:, 3) + ...
            A(:, 3) .* B(:, 1) .* C(:, 2) - A(:, 3) .* B(:, 2) .* C(:, 1);
        x = B(:, 1) .* C(:, 1) + B(:, 2) .* C(:, 2) + B(:, 3) .* C(:, 3) - ...
            (A(:, 1) .* C(:, 1) + A(:, 2) .* C(:, 2) + A(:, 3) .* C(:, 3)) .* ...
            (A(:, 1) .* B(:, 1) + A(:, 2) .* B(:, 2) + A(:, 3) .* B(:, 3));
        angles(:, j) = atan2(y, x);
    end

    % fix angle range (0 - 2pi)
    ind = find(angles < 0);
    angles(ind) = angles(ind) + 2 * pi;
    % calculate area_cst
    area_cst = sum(angles')' - 4 * pi / fnum - 2 * pi;
    % calculate angle_cst
    threshold = pi;
    tolerance = 10^(-8);
    bad_angles = find(angles > threshold + tolerance);
    angle_cst = angles(bad_angles) - threshold;

    return;
