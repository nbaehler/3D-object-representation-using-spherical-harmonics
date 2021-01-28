function [evs, svs] = improve_res(vertices, sph_verts, faces, res)
% improve resolution by adding more vertices
%

% global vertices;
% global sph_verts;
% global faces;

if (res<1)
    evs = vertices;
    svs = sph_verts;
    disp(sprintf('Resolution no change: %d',size(vertices,1)));
    return;
end

vnum = size(vertices,1);
fnum = size(faces,1);

% grid size
g = 2^res+1; % grid size

% create edges first
% 1 4
% 2 3
edges(:,:,1) = [faces(:,1),faces(:,2)];
edges(:,:,2) = [faces(:,4),faces(:,3)];
edges(:,:,3) = [faces(:,1),faces(:,4)];
edges(:,:,4) = [faces(:,2),faces(:,3)];

% calculate new points on edges
edge_evs = [];
edge_svs = [];
for e = 1:4
    evs(:,:,1) = vertices(edges(:,1,e),:);
    evs(:,:,g) = vertices(edges(:,2,e),:);
    svs(:,:,1) = sph_verts(edges(:,1,e),:);
    svs(:,:,g) = sph_verts(edges(:,2,e),:);
	for i = 1:res
        step = (g-1)/(2^(i-1));
        for k = 1:step:(g-1)
            evs(:,:,k+step/2) = (evs(:,:,k)+evs(:,:,k+step))/2;
            svs(:,:,k+step/2) = (svs(:,:,k)+svs(:,:,k+step))/2;
            vlen = sum(svs(:,:,k+step/2)'.^2).^(1/2);
            vlen = [vlen;vlen;vlen]';
            svs(:,:,k+step/2) = svs(:,:,k+step/2)./vlen;
        end
	end
    edge_evs(end+1:end+fnum,:,1:g-2) = evs(:,:,2:g-1);
    edge_svs(end+1:end+fnum,:,1:g-2) = svs(:,:,2:g-1);
end
clear evs svs;

% calculate new points inside faces
ptnum = fnum*(g-2);
evs(:,:,1) = reshape(permute(edge_evs(1:fnum,:,:),[1,3,2]),ptnum,3);
evs(:,:,g) = reshape(permute(edge_evs(fnum+1:fnum*2,:,:),[1,3,2]),ptnum,3);
svs(:,:,1) = reshape(permute(edge_svs(1:fnum,:,:),[1,3,2]),ptnum,3);
svs(:,:,g) = reshape(permute(edge_svs(fnum+1:fnum*2,:,:),[1,3,2]),ptnum,3);

for i = 1:res
    step = (g-1)/(2^(i-1));
    for k = 1:step:(g-1)
        evs(:,:,k+step/2) = (evs(:,:,k)+evs(:,:,k+step))/2;
        svs(:,:,k+step/2) = (svs(:,:,k)+svs(:,:,k+step))/2;
        vlen = sum(svs(:,:,k+step/2)'.^2).^(1/2);
        vlen = [vlen;vlen;vlen]';
        svs(:,:,k+step/2) = svs(:,:,k+step/2)./vlen;
    end
end

% collect new points inside faces
evs = evs(:,:,2:g-1);
svs = svs(:,:,2:g-1);
[d(1),d(2),d(3)] = size(evs);
ptnum = d(1)*d(3);
evs = reshape(permute(evs,[1,3,2]), ptnum, d(2));
svs = reshape(permute(svs,[1,3,2]), ptnum, d(2));

% collect edge points
edges = [faces(:,1),faces(:,2); ...
         faces(:,3),faces(:,4); ...
         faces(:,4),faces(:,1); ...
         faces(:,2),faces(:,3)];
ind = find((edges(:,1)-edges(:,2))<0);
len = length(ind);
edge_evs = edge_evs(ind,:,:);
edge_svs = edge_svs(ind,:,:);
[d(1),d(2),d(3)] = size(edge_evs);
ptnum = d(1)*d(3);
evs(end+1:end+ptnum,:) = reshape(permute(edge_evs,[1,3,2]), ptnum, d(2));
svs(end+1:end+ptnum,:) = reshape(permute(edge_svs,[1,3,2]), ptnum, d(2));

% collect original points
evs(end+1:end+vnum,:) = vertices;
svs(end+1:end+vnum,:) = sph_verts;

% #vs = fnum*4^(res)+2
disp(sprintf('Resolution from %d to %d',size(vertices,1),size(evs,1)));

return;
