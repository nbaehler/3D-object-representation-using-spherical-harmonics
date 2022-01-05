function verts = recal_longitude(verts, faces, edges, WAM, AM)
    % recalculate longitude

    [phi, theta] = cart2sph(verts(:, 1), verts(:, 2), verts(:, 3));

    ix = find(phi == -pi | phi == pi | theta == -pi / 2 | theta == pi / 2);

    if ~isempty(ix)
        disp(sprintf('%d longitudes == 0, do something', length(ix))); return;
    end

    % ix = find(abs(phi(edges(:,1))-phi(edges(:,2)))>pi);

    % phi2 = phi; ix = find(phi2<0);       phi2(ix) = phi2(ix)+pi*2;
    % phi3 = phi; ix = find(phi3<-pi/6);   phi3(ix) = phi3(ix)+pi*2;
    % phi4 = phi; ix = find(phi4<pi/6);    phi4(ix) = phi4(ix)+pi*2;
    % phi5 = phi; ix = find(phi5<-pi*5/6); phi5(ix) = phi5(ix)+pi*2;
    % phi6 = phi; ix = find(phi6<pi*5/6);  phi6(ix) = phi6(ix)+pi*2;
    % ix = find(abs(phi (edges(:,1))-phi (edges(:,2)))>pi ...
    %         | abs(phi2(edges(:,1))-phi2(edges(:,2)))>pi ...
    %         | abs(phi3(edges(:,1))-phi3(edges(:,2)))>pi ...
    %         | abs(phi4(edges(:,1))-phi4(edges(:,2)))>pi ...
    %         | abs(phi5(edges(:,1))-phi5(edges(:,2)))>pi ...
    %         | abs(phi6(edges(:,1))-phi6(edges(:,2)))>pi);

    phi2 = phi; ix = find(phi2 < 0); phi2(ix) = phi2(ix) + pi * 2;
    ix = find(abs(phi (edges(:, 1)) - phi (edges(:, 2))) > pi ...
        | abs(phi2(edges(:, 1)) - phi2(edges(:, 2))) > pi);

    % figure; hold on;
    % for i=1:length(ix)
    %     vs = verts(edges(ix(i),:),:);
    %     plot3(vs(:,1),vs(:,2),vs(:,3),'r-','LineWidth',3);
    % end
    % patch('vertices',verts,'faces',faces,'facecolor','w','edgecolor','k','facealpha',1);
    % view(3); axis equal; hold off;

    % Set up matrix B
    vn = size(verts, 1); d = [vn, vn];
    B = sparse(vn, vn);
    ind = find(WAM > 0); B(ind) = -1 ./ WAM(ind); % edges
    B(sub2ind(d, 1:vn, 1:vn)) = -sum(B); % diagonal

    % Set up constant vector b
    b = sparse(vn, 1);

    vix = edges(ix, :); vix = unique(vix);

    for k = 1:length(vix)
        i = vix(k);
        B(i, :) = 0; B(i, i) = 1; b(i) = phi(i);
    end

    disp('Solving simultaneous Linear Equations for longitude ...');
    phi = B \ b;

    [verts(:, 1), verts(:, 2), verts(:, 3)] = sph2cart(phi, theta, 1);

    % figure; hold on;
    % for i=1:length(ix)
    %     vs = verts(edges(ix(i),:),:);
    %     plot3(vs(:,1),vs(:,2),vs(:,3),'r-','LineWidth',3);
    % end
    % patch('vertices',verts,'faces',faces,'facecolor','w','edgecolor','k','facealpha',1);
    % view(3); axis equal; hold off;

    return;
