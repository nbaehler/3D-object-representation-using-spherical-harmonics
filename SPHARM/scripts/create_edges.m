function edges = create_edges(faces)
% create edges based on faces

fnum = size(faces,1);

edges(1:fnum,:)          = [faces(:,1),faces(:,2)];
edges((1:fnum)+fnum,:)   = [faces(:,2),faces(:,3)];
edges((1:fnum)+fnum*2,:) = [faces(:,3),faces(:,1)];
ind = find((edges(:,1)-edges(:,2))<0);
edges = edges(ind,:);

return;
