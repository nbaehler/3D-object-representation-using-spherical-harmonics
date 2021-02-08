% ============================================
% patch_shademesh.m
%
% Goal: surface shaded mesh rendering
%       need to open figure or subplot before use
%
% Li Shen
% 12/29/2006 - create

function [vs, fs, gc] = patch_shademesh(vs, fs, varargin)

if nargin>2
    lines = varargin{1};
else
    lines = [];
end

vertnum = size(vs,1);
meshsize = sqrt(vertnum)-1;

if (2^floor(log(meshsize)/log(2))==meshsize)
    d = [1 1]*(meshsize+1);
    gc{1} = con_2d_to_1d(meshsize/2+1,1:d(1),d);   % theta = 0,        z = 0
    gc{2} = con_2d_to_1d(1:d(1),meshsize/2+1,d);   % phi   = 0,      x > 0, y = 0
    gc{3} = con_2d_to_1d(1:d(1),meshsize*3/4+1,d); % phi   = pi/2,   x = 0, y > 0
    gc{4} = con_2d_to_1d(1:d(1),1,d);              % phi   = pi,     x < 0, y = 0
    gc{5} = con_2d_to_1d(1:d(1),meshsize/4+1,d);   % phi   = pi*3/2, x = 0, y < 0
else
    gc = [];
end

hold on;
patches = patch('faces', fs, 'vertices', vs, ...
		'FaceVertexCData', ones(size(vs,1),1)*[0.8 0.8 0.8], ...
		'FaceColor', 'interp', 'EdgeColor', 'k', 'LineWidth', 1);

light('position', [1 0 0]); light('position', [-1 0 0]);
light('position', [0 1 0]); light('position', [0 -1 0]);

material([.05 .4 .1 10]);
lighting phong

patch('Vertices', vs, 'Faces', fs, 'FaceVertexCData', hsv(size(vs,1)), 'FaceColor', 'none', 'EdgeColor', 'k');
shading flat;

if (~isempty(gc))
    pstr = ['-w';'-r';'-g';'-b';'-c'];
	% plot center circles
	for i = 1:5
        verts = vs(gc{i},:);
        plot3(verts(:,1),verts(:,2),verts(:,3),pstr(i,:),'LineWidth',3);
	end
	% south pole (sphere function starts from bottom to top, theta=pi)
	in = 1;
	plot3(vs(in,1),vs(in,2),vs(in,3),'r.','MarkerSize',40);
	% intersection of dateline and equator
	in = (1+vertnum)/2;
	plot3(vs(in,1),vs(in,2),vs(in,3),'b.','MarkerSize',40);
	% north pole (theta=0)
	in = vertnum;
	plot3(vs(in,1),vs(in,2),vs(in,3),'y.','MarkerSize',40);
end

ltstr = ['-r';'-y';'-g'];
for i=1:size(lines,1);
    plot3([lines(i,1) lines(i,4)],[lines(i,2) lines(i,5)],[lines(i,3) lines(i,6)], ...
          ltstr(mod(i-1,3)+1,:),'LineWidth',3);
end

axis image;
% box on;%by cvpr
% xlabel('x: right to left, yz: sagittal');
% ylabel('y: bottom to top, xz: axial');
% zlabel('z: back to front, xy: coronal (192)');
xlabel('x');
ylabel('y');
zlabel('z');
view(37.5, 15);

return;

%
% convert 2d index to 1d index
%

function is = con_2d_to_1d(xs, ys, d)

is = (ys-1)*d(1) + xs;

return;
