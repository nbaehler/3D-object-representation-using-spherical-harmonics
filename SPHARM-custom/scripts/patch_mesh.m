% ============================================
% patch_mesh.m
%
% Goal: surface mesh rendering
%       need to open figure or subplot before use
%
% Li Shen
% 02/21/2006 - create

function h = patch_mesh(vertices, faces)

    h = patch('faces', faces, 'vertices', vertices, ...
        'FaceColor', 'w', 'EdgeColor', 'k', 'FaceAlpha', 1); % transparancy can be adjusted by FaceAlpha
    axis image; box on; view(3);

    return;

    %
    % surface rendering with lighting
    %

    function patch_light(vertices, faces)

        patch('faces', faces, 'vertices', vertices, ...
            'FaceVertexCData', ones(size(vertices, 1), 1) * [.8 .8 .8], ...
            'FaceColor', 'interp', 'EdgeColor', 'none', 'FaceAlpha', 1, 'AmbientStrength', 0.8); % transparancy can be adjusted by FaceAlpha
        l1 = light('position', [-1 -1 .1], 'color', [.3 .3 .3] * 2);
        l2 = light('position', [1 -1 .1], 'color', [.3 .3 .3] * 2);
        l3 = light('position', [- .5 1 .1], 'color', [.3 .3 .3] * 2);
        l4 = light;
        % material shiny;
        % material metal;
        material([.3 .4 .2 10]);
        %  	lighting phong;
        lighting gouraud
        axis image; box on; view(3);

        return;
