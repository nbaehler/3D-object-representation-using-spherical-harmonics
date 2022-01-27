function [poles, dateline] = poles_dtln_floyd(vertices, neighbours, W)
    % all-pairs shortest path to determine north/south poles and dateline
    %   weighted version when vertices not empty
    %   use Floyd-Warshall algorithm

    % % calculate D, which contains the shortest-path weights
    % D = W;
    % dim = vertnum;
    % i = [1:dim];
    % spm_progress_bar('Init',dim,'shortest-path','points completed');
    % for k = 1:dim					% FLOYD'S ALGORITHM [O(n^3)]
    %     D(i,i) = min(D(i,i), D(i,k)*ones(1,dim)+ones(dim,1)*D(k,i));
    %     if (mod(k,50)==0)
    %         spm_progress_bar('Set',k);
    %     end
    % end
    % spm_progress_bar('Clear');

    % call a C implementation to calculate D for all pair shortest path
    disp('C implementation to calculate all pair shortest path ...');
    D = shortpath(W);

    d = size(W);

    % find poles by selecting two points with maximum distance in the mesh
    ind = find(D == max(max(D)));
    [poles(1), poles(2)] = gen_utils('con_1d_to_2d', ind(1), d);
    pole_distance = D(poles(1), poles(2));

    % north pole pi (z larger), south pole 0 (z smaller)
    if vertices(poles(1), 3) < vertices(poles(2), 3)
        poles([2, 1]) = poles;
    end

    % find the shortest path between poles
    disp('Find the shortest path between poles');
    cur_pt = poles(1);
    dateline = cur_pt;
    cur_len = 0;

    while cur_pt ~= poles(2)
        nb = neighbours{cur_pt};
        next_ind = gen_utils('con_2d_to_1d', cur_pt, nb, d);
        rema_ind = gen_utils('con_2d_to_1d', nb, poles(2), d);
        nb_ind = find((W(next_ind) + D(rema_ind) - (pole_distance - cur_len)) < 10^(-10));
        cur_pt = nb(nb_ind(1));
        dateline(end + 1) = cur_pt;
        cur_len = pole_distance - D(gen_utils('con_2d_to_1d', cur_pt, poles(2), d));
    end

    return;
