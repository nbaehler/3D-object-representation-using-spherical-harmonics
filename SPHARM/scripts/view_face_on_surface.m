function view_face_on_surface(verts, faces, ma_ind)
% plot specific faces on a surface
%

ma_cent = (verts(faces(ma_ind,1),:) + verts(faces(ma_ind,2),:) + verts(faces(ma_ind,3),:))/3;
figure; hold on; 
patch('Vertices', verts, 'Faces', faces, 'FaceVertexCData', hsv(size(verts,1)), 'FaceColor', 'w', 'EdgeColor', 'k');
shading flat; view(37.5, 15);
plot3(ma_cent(:,1), ma_cent(:,2), ma_cent(:,3),'r.','MarkerSize',20); axis equal; hold off;

return;

