function obj_area = cal_obj_area(vertices,faces)
% calculate relative areas of triangles on object surface net
%

A = faces(:,1); B = faces(:,2); C = faces(:,3);
a = sqrt(sum(((vertices(A,:)-vertices(B,:)).^(2))'))';
b = sqrt(sum(((vertices(B,:)-vertices(C,:)).^(2))'))';
c = sqrt(sum(((vertices(C,:)-vertices(A,:)).^(2))'))';
s = (a+b+c)/2;
obj_area = sqrt(s.*(s-a).*(s-b).*(s-c));
obj_area = obj_area/sum(obj_area);

return;
