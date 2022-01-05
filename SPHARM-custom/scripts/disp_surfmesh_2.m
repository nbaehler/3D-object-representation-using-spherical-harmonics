function disp_surfmesh(name, vertices, faces)
    % display surface mesh
    %

    vnum = size(vertices, 1); fnum = size(faces, 1);
    disp(sprintf('%s: %+4d = %d vertices * 2 - %d faces ', name, vnum * 2 - fnum, vnum, fnum));

    figure; hold on;
    %     patch('Vertices', vertices, 'Faces', faces, 'FaceVertexCData', hsv(size(vertices,1)), ...
    %            'FaceColor', 'w', 'EdgeColor', 'k'); shading flat;
    patch('faces', faces, 'vertices', vertices, ...
    'FaceVertexCData', ones(size(vertices, 1), 1) * [0.8 0.8 0.8], ...
        'FaceColor', [1 0 0], 'EdgeColor', 'interp', 'FaceAlpha', 1); % transparancy can be adjusted by FaceAlpha
    view(37.5, 15); axis equal;
    l1 = light('position', [-1 -1 .1], 'color', [.3 .3 .3]);
    l2 = light('position', [1 -1 .1], 'color', [.3 .3 .3]);
    l3 = light('position', [- .5 1 .1], 'color', [.3 .3 .3]);
    l4 = light;
    material([.3 .4 .2 10]);
    lighting phong;
    vertnum = size(vertices, 1);

    if vertnum < 50

        for i = 1:vertnum
            text(vertices(i, 1), vertices(i, 2), vertices(i, 3), num2str(i), 'FontWeight', 'bold');
        end

    end

    title(strrep(name, '_', '-'));
    axis off;
    hold off;

    return;
