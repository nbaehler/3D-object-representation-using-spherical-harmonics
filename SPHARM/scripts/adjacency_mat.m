function [AM, WAM] = adjacency_mat(vertices, edges)
    % calculate adjacency matrix and also weighted one
    %
    %     AM = n x n node-node adjacency matrix
    %         (Note: AM(i,j) = 0   => Arc (i,j) does not exist;
    %                AM(i,j) = 1   => Arc (i,j) exists)
    %                AM(i,j) = NaN => i==j)
    %     WAM = n x n node-node weighted adjacency matrix of arc lengths
    %         (Note: WAM(i,j) = 0   => Arc (i,j) does not exist;
    %                WAM(i,j) = NaN => Arc (i,j) exists with 0 weight)
    %

    n = size(vertices, 1);

    % edge weights matrix (weighted by 1 or the length of the edge)
    AM = sparse(n, n); WAM = sparse(n, n); d = [n, n];
    ind = sub2ind(d, edges(:, 1), edges(:, 2)); % gen_utils('con_2d_to_1d', edges(:, 1), edges(:, 2), d);
    AM(ind) = 1;
    AM = max(AM, AM');
    WAM(ind) = sqrt(sum((vertices(edges(:, 1), :) - vertices(edges(:, 2), :))'.^2)); WAM = max(WAM, WAM');

    % assign diagonal
    ind = sub2ind(d, 1:n, 1:n); % gen_utils('con_2d_to_1d', 1:n, 1:n, d);
    AM(ind) = NaN; WAM(ind) = NaN; % diagonal

    return;
