function [sph_verts, landmarks, dateline] = init_param_wt(vertices, faces, WAM, AM, landmarks)
    % initial parameterization (each edge weighted by its length)
    %   W is the edge weight matrix (spaital case: adjacency matrix, each edge has a weight of 1)
    %

    %%%%%%%%%%%%%%%%%%%%%%%%%
    % Latitude from Diffusion
    %%%%%%%%%%%%%%%%%%%%%%%%%

    % Set up matrix B
    vertnum = size(vertices, 1); d = [vertnum, vertnum];
    B = sparse(vertnum, vertnum);
    ind = find(WAM > 0); B(ind) = -1 ./ WAM(ind); % edges
    ind = gen_utils('con_2d_to_1d', 1:vertnum, 1:vertnum, d); B(ind) = -sum(B); % diagonal

    % max(B(:))
    % return

    % Set up matrix A
    A = B;
    % nouth pole
    A(landmarks(1), :) = 0;
    A(landmarks(1), landmarks(1)) = 1;
    % sorth pole
    A(landmarks(2), :) = 0;
    A(landmarks(2), landmarks(2)) = 1;

    % Set up constant vector b
    b = sparse(vertnum, 1);
    b(landmarks(1)) = pi;

    disp('Solving simultaneous Linear Equations for latitude ...');
    theta = A \ b;

    %%%%%%%%%%%%%%%%%%%%%%%%%%
    % Longitude from Diffusion
    %%%%%%%%%%%%%%%%%%%%%%%%%%

    % Set up matrix A
    A = B;
    % Cut link to pole
    for i = landmarks([1, 2])
        nbs = find(AM(i, :) == 1);
        ind = gen_utils('con_2d_to_1d', nbs, nbs, d);
        ind2 = gen_utils('con_2d_to_1d', nbs, i, d);
        A(ind) = A(ind) + B(ind2);
    end

    % generate dateline
    dateline = []; here = landmarks(1);

    while (here ~= landmarks(2))
        dateline(end + 1) = here;
        nbs = find(AM(here, :) == 1); [vv, next] = min(theta(nbs)); here = nbs(next(1));
    end

    dateline(end + 1) = here;

    % % generate dateline
    % dateline = []; here = landmarks(2);
    % while (here~=landmarks(1))
    %     dateline(end+1) = here;
    %     nbs = find(AM(here,:)==1); [vv, next] = max(theta(nbs)); here = nbs(next(1));
    % end
    % dateline(end+1) = here;
    % dateline = dateline(end:-1:1);

    % walk on date line (including north/south poles)
    for nd = dateline
        A(nd, :) = 0;
        A(nd, nd) = 1;
    end

    % Set up constant vector b
    b = sparse(vertnum, 1);
    % walk on date line (excluding north/south poles)
    for i = 2:length(dateline) - 1
        %     nbs = neighbours{dateline(i)};
        %     len = length(nbs);
        %     prev = find(nbs==dateline(i-1));
        %     next = find(nbs==dateline(i+1));
        % %     % counter clockwise becomes clockwise after switching the second and third columns
        % %     if next<prev
        % %         ind = next+1:prev-1;
        % %     else
        % %         ind = [next+1:len,1:prev-1];
        % %     end
        %     if prev<next
        %         ind = prev+1:next-1;
        %     else
        %         ind = [prev+1:len,1:next-1];
        %     end
        %     pts = nbs(ind)

        curr = dateline(i);
        ii1 = find(faces(:, 1) == curr); ii2 = find(faces(:, 2) == curr); ii3 = find(faces(:, 3) == curr);
        related_faces = [faces(ii1, :); faces(ii2, [2 3 1]); faces(ii3, [3 1 2])];
        pts = [];

        while ~isempty(related_faces)
            ii = find(ismember(related_faces(:, 2), [dateline(1:i - 1) pts]));

            switch length(ii)
                case 0
                    break;
                case 1
                    vv = related_faces(ii, 3);

                    if ismember(vv, dateline(i + 1:end))
                        break
                    end

                    pts(end + 1) = vv;
                    related_faces = [related_faces(1:(ii - 1), :); related_faces((ii + 1):end, :)];
                otherwise
                    disp(sprintf('There are %d choices. Investigate!', length(ii))); break;
            end

        end

        pts = pts';

        ind2 = gen_utils('con_2d_to_1d', pts, dateline(i), d);
        b(pts) = b(pts) - 2 * pi * B(ind2);
    end

    disp('Solving simultaneous Linear Equations for longitude ...');
    phi = A \ b;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % before this point
    %   theta: latitude (0,pi) (from south to north)
    %   phi: longitude (0,2pi)
    % after this point
    %   theta: longitude (-pi,pi)
    %   phi: latitude (-pi/2,pi/2)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    theta2 = phi;
    phi = theta - pi / 2;
    theta = theta2;
    ind = find(theta > pi);
    theta(ind) = theta(ind) - 2 * pi;
    clear theta2;

    landmarks = locate_landmarks(theta, phi, landmarks);
    landmarks = landmarks';

    [sph_verts(:, 1), sph_verts(:, 2), sph_verts(:, 3)] = sph2cart(theta, phi, 1);
    sph_verts = full(sph_verts);

    return;
