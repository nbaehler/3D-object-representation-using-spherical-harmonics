function [sph_verts,landmarks] = init_param(vertices,neighbours,dateline,landmarks)
% initial parameterization: each edge has the same weight of 1

%%%%%%%%%%%%%%%%%%%%%%%%%
% Latitude from Diffusion
%%%%%%%%%%%%%%%%%%%%%%%%%

% Set up matrix B
vertnum = size(vertices,1);
B = sparse(vertnum,vertnum);
for i = 1:vertnum
    nbs = neighbours{i};
    B(i,i) = length(nbs);
    B(i,nbs) = -1;
end
% Set up matrix A
A = B;
% nouth pole
A(landmarks(1),:) = 0;
A(landmarks(1),landmarks(1)) = 1;
% sorth pole
A(landmarks(2),:) = 0;
A(landmarks(2),landmarks(2)) = 1;

% Set up constant vector b
b = sparse(vertnum,1);
b(landmarks(1)) = pi;

disp('Solving simultaneous Linear Equations for latitude ...');
theta = A\b;

%%%%%%%%%%%%%%%%%%%%%%%%%%
% Longitude from Diffusion
%%%%%%%%%%%%%%%%%%%%%%%%%%

d = [vertnum, vertnum];

% Set up matrix A
A = B;
% Cut link to pole
for i=landmarks([1,2])
    nbs = neighbours{i};
    ind = gen_utils('con_2d_to_1d',nbs,nbs,d);
    A(ind) = A(ind)-1;
end
% walk on date line (including north/south poles)
for nd=dateline
    A(nd,:) = 0;
    A(nd,nd) = 1;
end

% Set up constant vector b
b = sparse(vertnum,1);
% walk on date line (excluding north/south poles)
for i=2:length(dateline)-1
    nbs = neighbours{dateline(i)};
    len = length(nbs);
    prev = find(nbs==dateline(i-1));
    next = find(nbs==dateline(i+1));
    % counter clockwise becomes clockwise after switching the second and third columns
    if next<prev
        ind = next+1:prev-1;
    else
        ind = [next+1:len,1:prev-1];
    end
    b(nbs(ind)) = b(nbs(ind))+2*pi;
end

disp('Solving simultaneous Linear Equations for longitude ...');
phi = A\b;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% before this point
%   theta: latitude (0,pi) (from south to north)
%   phi: longitude (0,2pi)
% after this point
%   theta: longitude (-pi,pi)
%   phi: latitude (-pi/2,pi/2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
theta2 = phi;
phi = theta-(pi/2);
theta = theta2;
ind = find(theta>pi);
theta(ind) = theta(ind)-2*pi;
clear theta2;

landmarks = locate_landmarks(theta,phi,landmarks);
landmarks = landmarks';

[sph_verts(:,1),sph_verts(:,2),sph_verts(:,3)] = sph2cart(theta,phi,1);
sph_verts = full(sph_verts);

return;
