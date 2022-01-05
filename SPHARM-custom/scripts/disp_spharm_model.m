function disp_spharm_model(vertices, faces)
    % display surface based on spherical harmonic descriptor
    % show 3 center great circles if meshsize == 2^k
    %

    h = figure;
    hold on;
    patches = patch('faces', faces, 'vertices', vertices, ...
        'FaceVertexCData', ones(size(vertices, 1), 1) * [0.8 0.8 0.8], ...
        'FaceColor', 'interp', 'EdgeColor', 'none');

    % light('position', [1 0 0]); light('position', [-1 0 0]);
    % light('position', [0 1 0]); light('position', [0 -1 0]);

    l1 = light('position', [-1 -1 .1], 'color', [.3 .3 .3]);
    l2 = light('position', [1 -1 .1], 'color', [.3 .3 .3]);
    l3 = light('position', [- .5 1 .1], 'color', [.3 .3 .3]);
    l4 = light;

    material([.3 .4 .2 10]);
    lighting phong;

    hold off;

    axis equal;
    box on;
    xlabel('x');
    ylabel('y');
    zlabel('z');
    view(37.5, 15);
    title(strrep(name, '_', '-'));

    % if (needtosave)
    %     saveas(h,fullfile(path, sprintf('%s_olfc', name)), 'png');
    %     close(h);
    % end

    return;
