function [vertices, landmarks] = resize_by_linear_dimension(vertices, landmarks)
    % This function rescales the vertices to the longest distance
    %	between landmark 5 and the first four landmarks.
    %
    % created by Mark McPeek 20 July 2007

    % find longest distance between these two landmarks
    first = landmarks(1, :);
    second = landmarks(2, :);
    diff = first - second;
    dists = sqrt(diag((diff * diff')));
    maxDist = max(dists);

    % second segment of length if needed
    first = landmarks(2, :);
    second = landmarks(4, :);
    diff = first - second;
    dists = sqrt(diag((diff * diff')));
    maxDist = maxDist + max(dists);

    % % or do it by picking distances from all possible
    % % calculate all distances among landmarks.
    % dists = pdist(landmarks);
    % % pick distance to use to resize shape
    % maxDist = dists(1) + dists(7);

    vertices = vertices / maxDist;
    landmarks = landmarks / maxDist;

    return;
