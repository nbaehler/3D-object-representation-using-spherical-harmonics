% ============================================
% gen_view.m
%
% view surface net on sphere
%
% Li Shen
% 08/14/2002 - create

function varargout = gen_view(choice, varargin)

    switch (choice)
        case 'disp_flat_net'
            sph_verts = varargin{1}; faces = varargin{2}; edges = varargin{3}; path = varargin{4};
            name = varargin{5}; needtosave = varargin{6};
            disp_flat_net(sph_verts, faces, edges, path, name, needtosave);
        case 'disp_sphere_quad'
            vertices = varargin{1}; faces = varargin{2}; edges = varargin{3}; path = varargin{4};
            name = varargin{5}; sphere_on = varargin{6}; od = varargin{7}; needtosave = varargin{8};
            disp_sphere_quad(vertices, faces, edges, path, name, sphere_on, od, needtosave);
        case 'disp_outline'
            vertices = varargin{1}; faces = varargin{2}; path = varargin{3}; name = varargin{4};
            needtosave = varargin{5};
            disp_outline(vertices, faces, path, name, needtosave);
        case 'disp_faces'
            vertices = varargin{1}; faces = varargin{2}; path = varargin{3}; name = varargin{4};
            needtosave = varargin{5};
            disp_faces(vertices, faces, path, name, needtosave);
        case 'disp_face_edge'
            vertices = varargin{1}; faces = varargin{2}; path = varargin{3}; name = varargin{4};
            needtosave = varargin{5};
            disp_face_edge(vertices, faces, path, name, needtosave);
        case 'disp_outline_info'
            vertices = varargin{1}; faces = varargin{2}; path = varargin{3}; name = varargin{4};
            dateline = varargin{5}; landmarks = varargin{6}; info = varargin{7}; needtosave = varargin{8};
            disp_outline_info(vertices, faces, path, name, dateline, landmarks, info, needtosave);
        case 'disp_faces_info'
            vertices = varargin{1}; faces = varargin{2}; path = varargin{3}; name = varargin{4};
            dateline = varargin{5}; landmarks = varargin{6}; info = varargin{7}; needtosave = varargin{8};
            disp_faces_info(vertices, faces, path, name, dateline, landmarks, info, needtosave);
        case 'disp_spharm_desc'
            fvec = varargin{1}; meshsize = varargin{2}; dg = varargin{3}; path = varargin{4};
            name = varargin{5}; lines = varargin{6}; needtosave = varargin{7};
            disp_spharm_desc(fvec, meshsize, dg, path, name, lines, needtosave)
        case 'disp_spharm'
            lm = varargin{1};
            disp_spharm(lm);
        case 'disp_deform'
            vertices = varargin{1}; faces = varargin{2}; vs_defm = varargin{3};
            dispstr = varargin{4}; path = varargin{5}; name = varargin{6}; needtosave = varargin{7};
            disp_deform(vertices, faces, vs_defm, dispstr, path, name, needtosave);
        case 'disp_multiobjs'
            vertices = varargin{1}; faces = varargin{2}; name = varargin{3}; tcolor = varargin{4};
            trans = varargin{5}; needtosave = varargin{6};
            disp_multiobjs(vertices, faces, name, tcolor, trans, needtosave);
        case 'disp_verts_many'
            vss = varargin{1}; fss = varargin{2}; plot_res = varargin{3}; path = varargin{4};
            names = varargin{5}; needtosave = varargin{6};
            disp_verts_many(vss, fss, plot_res, path, names, needtosave);
        otherwise
            disp(sprintf('%s: no such gen_view routine', choice));
    end

    return;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Draw multiple subjects in one figure
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %
    % Display many SPHARMs in a few figures
    %

    function disp_verts_many(vss, fss, plot_res, path, names, needtosave)
        global fhs; % required by sph10_rotate

        % determine axis scaling
        xmin = Inf; xmax = -Inf;
        ymin = Inf; ymax = -Inf;
        zmin = Inf; zmax = -Inf;

        for k = 1:length(vss)
            vertices = real(vss{k});
            xmin = min(xmin, min(vertices(:, 1))); xmax = max(xmax, max(vertices(:, 1)));
            ymin = min(ymin, min(vertices(:, 2))); ymax = max(ymax, max(vertices(:, 2)));
            zmin = min(zmin, min(vertices(:, 3))); zmax = max(zmax, max(vertices(:, 3)));
        end

        bbox = sprintf('[%0.2f %0.2f %0.2f %0.2f %0.2f %0.2f]', ...
            [xmin xmax ymin ymax zmin zmax]);

        plotx = plot_res(1);
        ploty = plot_res(2);
        plotn = plotx * ploty;

        for k = 1:length(vss)

            j = mod(k - 1, plotn);

            if (j == 0)
                fig = figure('Name', bbox);
            end

            vertices = vss{k};
            faces = fss{k};
            name = names{k};

            fhs(end + 1, :) = [fig, subplot(plotx, ploty, j + 1)];

            hold on;
            patches = patch('faces', faces, 'vertices', vertices, ...
                'FaceVertexCData', ones(size(vertices, 1), 1) * [0.8 0.8 0.8], ...
                'FaceColor', 'interp', 'EdgeColor', 'none');

            % 	l1 = light('position', [-1 -1 .1], 'color', [.3 .3 .3]);
            % 	l2 = light('position', [1 -1 .1], 'color', [.3 .3 .3]);
            % 	l3 = light('position', [-.5 1 .1], 'color', [.3 .3 .3]);
            % 	l4 = light;

            l1 = light('position', [-1 -1 .1]);
            l2 = light('position', [1 -1 .1]);
            l3 = light('position', [- .5 1 .1]);
            l4 = light;

            material([.05 .4 .1 10]);
            lighting phong

            % 	patch('Vertices', vertices, 'Faces', faces, 'FaceVertexCData', hsv(size(vertices,1)), 'FaceColor', 'none', 'EdgeColor', 'k');
            % 	shading flat;

            hold off;

            %	axis equal;
            axis([xmin xmax ymin ymax zmin zmax]);
            axis equal;
            axis off;
            box on;
            view(210, 10);
            title(strrep(name, '_', '-'));

        end

        sph10_rotate;

        return;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Display flat net
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %
        % display flat net (theta vs. sin(phi)=z)
        % different from disp_flat_net in sph10_view.m
        %

        function disp_flat_net(sph_verts, faces, edges, path, name, needtosave)

            [xs, ys] = cart2sph(sph_verts(:, 1), sph_verts(:, 2), sph_verts(:, 3));
            ind = find(xs < 0);
            xs(ind) = xs(ind) + 2 * pi;
            % ys = sin(ys);
            ys = sph_verts(:, 3);

            % break cross-edges
            ind = find(abs(xs(edges(:, 1)) - xs(edges(:, 2))) > pi);

            for i = 1:length(ind)
                e = edges(ind(i), :);

                if (xs(e(1)) < xs((e(2))))
                    west = e(1);
                    east = e(2);
                else
                    west = e(2);
                    east = e(1);
                end

                by = ys(east) + (2 * pi - xs(east)) * (ys(west) - ys(east)) / (xs(west) + 2 * pi - xs(east));
                xs(end + 1:end + 2) = [0; 2 * pi];
                ys(end + 1:end + 2) = [by; by];
                wb = length(xs) - 1;
                edges(ind(i), :) = [wb, west]; % fix west side
                edges(end + 1, :) = [east, wb + 1]; % fix east side
            end

            vertnum = length(xs);
            A = sparse(vertnum, vertnum);
            A(edges(:, 1) + (edges(:, 2) - 1) * vertnum) = 1;

            h = figure;
            hold on;

            %scatter(xs,ys);

            gplot(A, [xs, ys]);

            if vertnum < 80

                for i = 1:vertnum
                    text(xs(i), ys(i), num2str(i), 'FontWeight', 'bold');
                end

            end

            hold off;

            axis tight;
            box on;
            xlabel('theta');
            ylabel('sin(phi)');
            title(strrep(name, '_', '-'));

            % if (needtosave)
            %     saveas(h,fullfile(path, sprintf('%s_flat', name)), 'png');
            %     close(h);
            % end

            return;

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Display spherical quadrilaterals
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            %
            % display spherical quadrilaterals
            %

            function disp_sphere_quad(vs, faces, edges, path, name, sphere_on, od, needtosave)

                h = figure;
                hold on;

                fnum = size(faces, 1);

                if (fnum > 1000)
                    patch('Vertices', vs, 'Faces', faces, 'FaceVertexCData', hsv(size(vs, 1)), 'FaceColor', 'none', 'EdgeColor', 'k');
                    shading flat;
                else

                    if (sphere_on)
                        sphere;
                        colormap white;
                    end

                    enum = size(edges, 1);

                    for i = 1:enum
                        head = vs(edges(i, 1), :);
                        tail = vs(edges(i, 2), :);
                        t = 0:1 / ceil(25 * norm(head - tail)):1;
                        xs = head(1) + (tail(1) - head(1)) * t;
                        ys = head(2) + (tail(2) - head(2)) * t;
                        zs = head(3) + (tail(3) - head(3)) * t;
                        ls = sqrt(xs.^2 + ys.^2 + zs.^2);
                        plot3(xs ./ ls, ys ./ ls, zs ./ ls, 'LineWidth', 1.5);
                    end

                end

                vertnum = size(vs, 1);

                if vertnum < 80

                    for i = 1:vertnum
                        text(vs(i, 1), vs(i, 2), vs(i, 3), num2str(i), 'FontWeight', 'bold');
                    end

                end

                hold off;

                axis equal;
                box on;
                xlabel('x');
                ylabel('y');
                zlabel('z');
                view(37.5, 15);
                title(strrep(name, '_', '-'));

                % if (needtosave)
                %     saveas(h,fullfile(path, sprintf('%s_spol_%s', name, od)), 'png');
                %     close(h);
                % end

                return;

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Display surface and surface net
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                %
                % display outline of faces
                %

                function disp_outline(vertices, faces, path, name, needtosave)

                    if iscell(vertices)
                        vertgrp = vertices; facegrp = faces;
                    else
                        vertgrp{1} = vertices; facegrp{1} = faces;
                    end

                    h = figure;
                    hold on;

                    for i = 1:length(vertgrp)
                        vertices = vertgrp{i}; faces = facegrp{i};
                        patch('Vertices', vertices, 'Faces', faces, 'FaceVertexCData', hsv(size(vertices, 1)), 'FaceColor', 'w', 'EdgeColor', 'k');
                        shading flat;
                        view(37.5, 15);
                        plot3([0 0], [0 0], [1 -1], 'd');
                        % 	patches = patch('faces', faces, 'vertices', vertices, ...
                        % 			'FaceVertexCData', ones(size(vertices,1),1)*[0.8 0.8 0.8], ...
                        % 			'FaceColor', 'none', 'EdgeColor', 'k', 'LineWidth', 2); % transparancy can be adjusted by FaceAlpha
                    end

                    % % light('position', [1 0 0]); light('position', [-1 0 0]);
                    % % light('position', [0 1 0]); light('position', [0 -1 0]);
                    % l1 = light('position', [-1 -1 .1], 'color', [.3 .3 .3]);
                    % l2 = light('position', [1 -1 .1], 'color', [.3 .3 .3]);
                    % l3 = light('position', [-.5 1 .1], 'color', [.3 .3 .3]);
                    % l4 = light;
                    %
                    % material([.3 .4 .2 10]);
                    % lighting phong;

                    % vertnum = size(vertices,1);
                    % if vertnum<50
                    %     for i = 1:vertnum
                    %         text(vertices(i,1),vertices(i,2),vertices(i,3),num2str(i),'FontWeight','bold');
                    %     end
                    % end

                    hold off;

                    axis equal; xlabel('x'); ylabel('y'); zlabel('z');
                    % box on;
                    % xlabel('x: right to left, yz: sagittal');
                    % ylabel('y: bottom to top, xz: axial');
                    % zlabel('z: back to front, xy: coronal (192)');
                    % view(37.5, 15);
                    % title(strrep(name,'_','-'));

                    % if (needtosave)
                    %     saveas(h,fullfile(path, sprintf('%s_outl', name)), 'eps');
                    %     close(h);
                    % end

                    return;

                    %
                    % display faces
                    %

                    function disp_faces(vertices, faces, path, name, needtosave)

                        if iscell(vertices)
                            vertgrp = vertices; facegrp = faces;
                        else
                            vertgrp{1} = vertices; facegrp{1} = faces;
                        end

                        tcolor = [1 0 0; 0 0 1; 0.3 0.3 0.3];
                        h = figure;
                        hold on;

                        for i = 1:length(vertgrp)
                            vertices = vertgrp{i}; faces = facegrp{i};
                            %     % switch x y z to have a regular looking
                            %     vertices = [vertices(:,1),-vertices(:,3),vertices(:,2)];
                            k = mod(i - 1, size(tcolor, 1)) + 1;
                            patches = patch('faces', faces, 'vertices', vertices, ...
                                'FaceVertexCData', ones(size(vertices, 1), 1) * [0.8 0.8 0.8], ...
                                'FaceColor', tcolor(k, :), 'EdgeColor', 'none', 'FaceAlpha', 1); % transparancy can be adjusted by FaceAlpha

                        end

                        l1 = light('position', [-1 -1 .1], 'color', [.3 .3 .3]);
                        l2 = light('position', [1 -1 .1], 'color', [.3 .3 .3]);
                        l3 = light('position', [- .5 1 .1], 'color', [.3 .3 .3]);
                        l4 = light;
                        % material shiny;
                        % material metal;
                        material([.3 .4 .2 10]);
                        lighting phong;

                        axis equal;
                        box on;
                        xlabel('x');
                        ylabel('y');
                        zlabel('z');
                        title(strrep(name, '_', '-'));
                        view(37.5, 15);

                        % if (needtosave)
                        %     saveas(h,fullfile(path, sprintf('%s_face', name)), 'png');
                        %     close(h);
                        % end

                        hold off;

                        return;

                        %
                        % display faces and edges
                        %

                        function disp_face_edge(vertices, faces, path, name, needtosave)

                            if iscell(vertices)
                                vertgrp = vertices; facegrp = faces;
                            else
                                vertgrp{1} = vertices; facegrp{1} = faces;
                            end

                            tcolor = [1 0 0; 0 0 1; 0.3 0.3 0.3];
                            h = figure;
                            hold on;

                            for i = 1:length(vertgrp)
                                vertices = vertgrp{i}; faces = facegrp{i};
                                %     % switch x y z to have a regular looking
                                %     vertices = [vertices(:,1),-vertices(:,3),vertices(:,2)];
                                k = mod(i - 1, size(tcolor, 1)) + 1;
                                patches = patch('faces', faces, 'vertices', vertices, ...
                                    'FaceVertexCData', ones(size(vertices, 1), 1) * [0.8 0.8 0.8], ...
                                    'FaceColor', tcolor(k, :), 'EdgeColor', 'interp', 'FaceAlpha', 1); % transparancy can be adjusted by FaceAlpha

                            end

                            l1 = light('position', [-1 -1 .1], 'color', [.3 .3 .3]);
                            l2 = light('position', [1 -1 .1], 'color', [.3 .3 .3]);
                            l3 = light('position', [- .5 1 .1], 'color', [.3 .3 .3]);
                            l4 = light;
                            % material shiny;
                            % material metal;
                            material([.3 .4 .2 10]);
                            lighting phong;

                            vertnum = size(vertices, 1);

                            if vertnum < 50

                                for i = 1:vertnum
                                    text(vertices(i, 1), vertices(i, 2), vertices(i, 3), num2str(i), 'FontWeight', 'bold');
                                end

                            end

                            axis equal;
                            box on;
                            xlabel('x');
                            ylabel('y');
                            zlabel('z');
                            title(strrep(name, '_', '-'));
                            view(37.5, 15);

                            % if (needtosave)
                            %     saveas(h,fullfile(path, sprintf('%s_face', name)), 'png');
                            %     close(h);
                            % end

                            hold off;

                            return;

                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            % Display surface and surface net with dateline and landmarks
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                            %
                            % display outline of faces and dateline
                            %

                            function disp_outline_info(vertices, faces, path, name, dateline, landmarks, info, needtosave)

                                h = figure;
                                hold on;
                                patch('Vertices', vertices, 'Faces', faces, 'FaceVertexCData', hsv(size(vertices, 1)), 'FaceColor', 'none', 'EdgeColor', 'k');
                                shading flat;
                                vertnum = size(vertices, 1);

                                if vertnum < 50

                                    for i = 1:vertnum
                                        text(vertices(i, 1), vertices(i, 2), vertices(i, 3), num2str(i), 'FontWeight', 'bold');
                                    end

                                end

                                % plot date line
                                plot3(vertices(dateline, 1), vertices(dateline, 2), vertices(dateline, 3), '-k', 'LineWidth', 2);

                                % plot landmarks
                                markstr = 'NSEW';

                                for i = 1:4
                                    ind = landmarks(i);
                                    text(vertices(ind, 1), vertices(ind, 2), vertices(ind, 3), ...
                                        sprintf('%s:%d', markstr(i), ind), 'FontWeight', 'bold');
                                end

                                hold off;

                                axis equal;
                                box on;
                                xlabel('x');
                                ylabel('y');
                                zlabel('z');
                                view(37.5, 15);
                                title(strrep(name, '_', '-'));

                                % if (needtosave)
                                %     saveas(h,fullfile(path, sprintf('%s_%s', name, info)), 'png');
                                %     close(h);
                                % end

                                return;

                                %
                                % display faces and date line
                                %

                                function disp_faces_info(vertices, faces, path, name, dateline, landmarks, info, needtosave)

                                    h = figure;
                                    hold on;
                                    patches = patch('faces', faces, 'vertices', vertices, ...
                                        'FaceVertexCData', ones(size(vertices, 1), 1) * [0.8 0.8 0.8], ...
                                        'FaceColor', 'interp', 'EdgeColor', 'none');

                                    l1 = light('position', [-1 -1 .1], 'color', [.3 .3 .3]);
                                    l2 = light('position', [1 -1 .1], 'color', [.3 .3 .3]);
                                    l3 = light('position', [- .5 1 .1], 'color', [.3 .3 .3]);
                                    l4 = light;
                                    material([.05 .4 .1 10]);
                                    lighting phong

                                    % plot date line
                                    plot3(vertices(dateline, 1), vertices(dateline, 2), vertices(dateline, 3), '-r', 'LineWidth', 2);

                                    % plot landmarks
                                    markstr = 'NSEW';

                                    for i = 1:4
                                        ind = landmarks(i);
                                        text(vertices(ind, 1), vertices(ind, 2), vertices(ind, 3), ...
                                            sprintf('%s:%d', markstr(i), ind), 'FontWeight', 'bold', 'Color', 'r');
                                    end

                                    hold off;

                                    axis equal;
                                    box on;
                                    xlabel('x');
                                    ylabel('y');
                                    zlabel('z');
                                    title(strrep(name, '_', '-'));
                                    view(37.5, 15);

                                    % if (needtosave)
                                    %     saveas(h,fullfile(path, sprintf('%s_%s', name, info)), 'png');
                                    %     close(h);
                                    % end

                                    return;

                                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                    % Display surface and surface net based on SPHARM
                                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                                    %
                                    % display surface based on spherical harmonic descriptor
                                    % show 3 center great circles if meshsize == 2^k
                                    %

                                    function disp_spharm_desc(fvec, meshsize, dg, path, name, lines, needtosave)
                                        % function disp_spharm_desc(fvec,meshsize,degree,lines)

                                        % adjust degree based on fvec
                                        max_d = sqrt(size(fvec, 1)) - 1;

                                        if (dg(1) < 0 | dg(2) > max_d)
                                            odg = dg;
                                            dg(1) = max(dg(1), 0);
                                            dg(2) = min(dg(2), max_d);
                                            disp(sprintf('degree [%d %d] adjusted to the possible range [%d %d]', odg, dg));
                                        else
                                            disp(sprintf('degree [%d %d]', dg));
                                        end

                                        % sph11_can_basis(meshsize, degree, fast)
                                        % if need gc, set (fast~=1)
                                        [Z, fs] = sph11_can_basis(meshsize, dg(2), 0);

                                        lb = dg(1)^2 + 1;
                                        ub = (dg(2) + 1)^2;

                                        vs = Z(:, lb:ub) * fvec(lb:ub, :);

                                        if (2^floor(log(meshsize) / log(2)) == meshsize)
                                            d = [1 1] * (meshsize + 1);
                                            gc{1} = con_2d_to_1d(meshsize / 2 + 1, 1:d(1), d); % phi = 0,        z = 0
                                            gc{2} = con_2d_to_1d(1:d(1), meshsize / 2 + 1, d); % theta = 0,      x > 0, y = 0
                                            gc{3} = con_2d_to_1d(1:d(1), meshsize * 3/4 + 1, d); % theta = pi/2,   x = 0, y > 0
                                            gc{4} = con_2d_to_1d(1:d(1), 1, d); % theta = pi,     x < 0, y = 0
                                            gc{5} = con_2d_to_1d(1:d(1), meshsize / 4 + 1, d); % theta = pi*3/2, x = 0, y < 0
                                        else
                                            gc = [];
                                        end

                                        disp_outlface(vs, fs, path, name, gc, lines, needtosave);

                                        % disp_outline(vs, fs, 'spherical', 'harmonics');
                                        % disp_faces(vs, faces, 'spherical', 'harmonics');

                                        return;

                                        %
                                        % display outlines and faces
                                        %

                                        function disp_outlface(vertices, faces, path, name, gc, lines, needtosave)
                                            global Ap;
                                            global App;
                                            global eig_vec;

                                            vertices = real(vertices);

                                            h = figure;
                                            hold on;
                                            patches = patch('faces', faces, 'vertices', vertices, ...
                                                'FaceVertexCData', ones(size(vertices, 1), 1) * [0.8 0.8 0.8], ...
                                                'FaceColor', 'interp', 'EdgeColor', 'k', 'LineWidth', 1);

                                            % l1 = light('position', [-1 -1 .1], 'color', [.3 .3 .3]);
                                            % l2 = light('position', [1 -1 .1], 'color', [.3 .3 .3]);
                                            % l3 = light('position', [-.5 1 .1], 'color', [.3 .3 .3]);
                                            % l4 = light;

                                            light('position', [1 0 0]); light('position', [-1 0 0]);
                                            light('position', [0 1 0]); light('position', [0 -1 0]);

                                            material([.05 .4 .1 10]);
                                            lighting phong

                                            patch('Vertices', vertices, 'Faces', faces, 'FaceVertexCData', hsv(size(vertices, 1)), 'FaceColor', 'none', 'EdgeColor', 'k');
                                            shading flat;

                                            vertnum = size(vertices, 1);

                                            if vertnum < 50

                                                for i = 1:vertnum
                                                    text(vertices(i, 1), vertices(i, 2), vertices(i, 3), num2str(i), 'FontWeight', 'bold');
                                                end

                                            end

                                            if (~isempty(gc))
                                                pstr = ['-w'; '-r'; '-g'; '-b'; '-c'];
                                                % plot center circles
                                                for i = 1:5
                                                    verts = vertices(gc{i}, :);
                                                    plot3(verts(:, 1), verts(:, 2), verts(:, 3), pstr(i, :), 'LineWidth', 3);
                                                end

                                                % south pole (sphere function starts from bottom to top, theta=pi)
                                                in = 1;
                                                plot3(vertices(in, 1), vertices(in, 2), vertices(in, 3), 'r.', 'MarkerSize', 40);
                                                % intersection of dateline and equator
                                                in = (1 + vertnum) / 2;
                                                plot3(vertices(in, 1), vertices(in, 2), vertices(in, 3), 'b.', 'MarkerSize', 40);
                                                % north pole (theta=0)
                                                in = vertnum;
                                                plot3(vertices(in, 1), vertices(in, 2), vertices(in, 3), 'y.', 'MarkerSize', 40);
                                            end

                                            ltstr = ['-r'; '-y'; '-g'];

                                            for i = 1:size(lines, 1);
                                                plot3([lines(i, 1) lines(i, 4)], [lines(i, 2) lines(i, 5)], [lines(i, 3) lines(i, 6)], ...
                                                    ltstr(mod(i - 1, 3) + 1, :), 'LineWidth', 3);
                                            end

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

                                            %
                                            % convert 2d index to 1d index
                                            %

                                            function is = con_2d_to_1d(xs, ys, d)

                                                is = (ys - 1) * d(1) + xs;

                                                return;

                                                %
                                                % create edges based on faces
                                                %

                                                function edges = create_edges()
                                                    global faces;

                                                    fnum = size(faces, 1);

                                                    edges(1:fnum, :) = [faces(:, 1), faces(:, 2)];
                                                    edges((1:fnum) + fnum, :) = [faces(:, 2), faces(:, 3)];
                                                    edges((1:fnum) + fnum * 2, :) = [faces(:, 3), faces(:, 4)];
                                                    edges((1:fnum) + fnum * 3, :) = [faces(:, 4), faces(:, 1)];
                                                    ind = find((edges(:, 1) - edges(:, 2)) < 0);
                                                    edges = edges(ind, :);

                                                    return;

                                                    %
                                                    % display spherical harmonics
                                                    % value as the radius of the surface
                                                    %

                                                    function disp_spharm(lm)

                                                        sn = 20;
                                                        [x, y, z] = sphere(sn);
                                                        [faces, v, c] = surf2patch(x, y, z);
                                                        [PHI, THETA] = cart2sph(x, y, z);
                                                        THETA = reshape(THETA, 1, (sn + 1)^2);
                                                        PHI = reshape(PHI, 1, (sn + 1)^2);
                                                        nPHI = PHI;
                                                        % ind = find(nPHI<0);
                                                        % nPHI(ind) = nPHI(ind)+2*pi;
                                                        nPHI = PHI + pi;
                                                        nTHETA = THETA + pi / 2;
                                                        vertnum = length(THETA);

                                                        % for i = 1:vertnum
                                                        %     Z(i,:) = spharm_basis(10,nTHETA(i),nPHI(i));
                                                        % end

                                                        % sph11_can_basis(meshsize, degree, fast)
                                                        [Z, fs] = sph11_can_basis(sn, max(lm(:, 1)), 1);

                                                        for i = 1:size(lm, 1)
                                                            j = lm(i, 1)^2 + lm(i, 1) + lm(i, 2) + 1;
                                                            [vs(:, 1), vs(:, 2), vs(:, 3)] = sph2cart(PHI', THETA', real(Z(:, j)).^2);
                                                            disp_outline(vs, faces, '', ...
                                                                sprintf('spherical harmonic (%d, %d: real)', lm(i, :)), 0);
                                                            [vs(:, 1), vs(:, 2), vs(:, 3)] = sph2cart(PHI', THETA', imag(Z(:, j)).^2);
                                                            disp_outline(vs, faces, '', ...
                                                                sprintf('spherical harmonic (%d, %d: imaginary)', lm(i, :)), 0);
                                                            [vs(:, 1), vs(:, 2), vs(:, 3)] = sph2cart(PHI', THETA', abs(Z(:, j)).^2);
                                                            disp_outline(vs, faces, '', ...
                                                                sprintf('spherical harmonic (%d, %d: norm)', lm(i, :)), 0);
                                                            %    disp_faces(vs, faces, '', 'spherical harmonics');
                                                        end

                                                        return;

                                                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                                        % Display deformation fields and object comparison
                                                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                                                        %
                                                        % display deformation fields
                                                        %

                                                        function disp_deform(vertices, faces, vs_defm, dispstr, path, name, needtosave)

                                                            tcolor = [1 0 0; 0 0 1; 0.3 0.3 0.3];
                                                            h = figure;
                                                            hold on;

                                                            switch dispstr
                                                                case 'colormap'
                                                                    cdata = sqrt(sum((vs_defm.^2)'))';
                                                                    patches = patch('faces', faces, 'vertices', vertices, ...
                                                                        'FaceVertexCData', cdata, ...
                                                                        'FaceColor', 'interp', 'EdgeColor', 'none', 'FaceAlpha', 1); % transparancy can be adjusted by FaceAlpha
                                                                case 'vector'
                                                                    patches = patch('faces', faces, 'vertices', vertices, ...
                                                                        'FaceVertexCData', ones(size(vertices, 1), 1) * [0.8 0.8 0.8], ...
                                                                        'FaceColor', [1 0 0], 'EdgeColor', 'none', 'FaceAlpha', 0.3); % transparancy can be adjusted by FaceAlpha
                                                            end

                                                            % l1 = light('position', [-1 -1 .1], 'color', [.3 .3 .3]);
                                                            % l2 = light('position', [1 -1 .1], 'color', [.3 .3 .3]);
                                                            % l3 = light('position', [-.5 1 .1], 'color', [.3 .3 .3]);
                                                            % l4 = light;
                                                            % % material shiny;
                                                            % % material metal;
                                                            % material([.3 .4 .2 10]);
                                                            % lighting phong;

                                                            vertnum = size(vertices, 1);

                                                            if vertnum < 50

                                                                for i = 1:vertnum
                                                                    text(vertices(i, 1), vertices(i, 2), vertices(i, 3), num2str(i), 'FontWeight', 'bold');
                                                                end

                                                            end

                                                            % deformation
                                                            vs_mean = vertices;
                                                            X = vs_mean(:, 1); Y = vs_mean(:, 2); Z = vs_mean(:, 3);
                                                            U = vs_defm(:, 1); V = vs_defm(:, 2); W = vs_defm(:, 3);
                                                            % quiver3(X,Y,Z,U,V,W,2,'k');

                                                            colormap summer;

                                                            axis equal; axis off; box on;
                                                            xlabel('x');
                                                            ylabel('y');
                                                            zlabel('z');
                                                            title(strrep(name, '_', '-'));
                                                            view(210, 10);

                                                            colorbar;

                                                            % if (needtosave)
                                                            %     name = strrep(name,' ','-');
                                                            %     title(sprintf('%s (37.5, 15)',name));
                                                            %     saveas(h, sprintf('df_%s_01', name), 'png');
                                                            %     view(217.5, 15);
                                                            %     title(sprintf('%s (217.5, 15)',name));
                                                            %     saveas(h, sprintf('df_%s_02', name), 'png');
                                                            %     close(h);
                                                            % end

                                                            hold off;

                                                            return;

                                                            %
                                                            % display multiple objects with different colors and adjustable transparancy
                                                            %

                                                            function disp_multiobjs(vertices, faces, name, tcolor, trans, needtosave)

                                                                if iscell(vertices)
                                                                    vertgrp = vertices; facegrp = faces;
                                                                else
                                                                    vertgrp{1} = vertices; facegrp{1} = faces;
                                                                end

                                                                h = figure;
                                                                hold on;

                                                                for i = 1:length(vertgrp)
                                                                    vertices = vertgrp{i}; faces = facegrp{i};
                                                                    %     % switch x y z to have a regular looking
                                                                    %     vertices = [vertices(:,1),-vertices(:,3),vertices(:,2)];
                                                                    k = mod(i - 1, size(tcolor, 1)) + 1;
                                                                    patches = patch('faces', faces, 'vertices', vertices, ...
                                                                        'FaceVertexCData', ones(size(vertices, 1), 1) * [0.8 0.8 0.8], ...
                                                                        'FaceColor', tcolor(k, :), 'EdgeColor', 'none', 'FaceAlpha', trans); % transparancy can be adjusted by FaceAlpha
                                                                end

                                                                l1 = light('position', [-1 -1 .1], 'color', [.3 .3 .3]);
                                                                l2 = light('position', [1 -1 .1], 'color', [.3 .3 .3]);
                                                                l3 = light('position', [- .5 1 .1], 'color', [.3 .3 .3]);
                                                                l4 = light;
                                                                % material shiny;
                                                                % material metal;
                                                                material([.3 .4 .2 10]);
                                                                lighting phong;

                                                                axis equal;
                                                                box on;
                                                                xlabel('x');
                                                                ylabel('y');
                                                                zlabel('z');
                                                                title(strrep(name, '_', '-'));
                                                                view(37.5, 15);

                                                                % if (needtosave)
                                                                %     name = strrep(name,' ','-');
                                                                %     title(sprintf('%s (37.5, 15)',name));
                                                                %     saveas(h, sprintf('mo_%s_01', name), 'png');
                                                                %     view(217.5, 15);
                                                                %     title(sprintf('%s (217.5, 15)',name));
                                                                %     saveas(h, sprintf('mo_%s_02', name), 'png');
                                                                %     close(h);
                                                                % end

                                                                hold off;

                                                                return;
