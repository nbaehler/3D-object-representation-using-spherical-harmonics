function par_area = cal_par_area(vs,faces)
% calculate relative areas of spherical triangles in parameter space
%

angles = [];
for j = 1:3
    % note that the order of A B C is clockwise (see 08-22-02.htm notes)
    A = vs(faces(:,j),:);
    B = vs(faces(:,mod(j,3)+1),:);
    C = vs(faces(:,mod(j-2,3)+1),:);
    y = A(:,1).*B(:,2).*C(:,3) - A(:,1).*B(:,3).*C(:,2) + ...
        A(:,2).*B(:,3).*C(:,1) - A(:,2).*B(:,1).*C(:,3) + ...
        A(:,3).*B(:,1).*C(:,2) - A(:,3).*B(:,2).*C(:,1);
    x = B(:,1).*C(:,1) + B(:,2).*C(:,2) + B(:,3).*C(:,3) - ...
       (A(:,1).*C(:,1) + A(:,2).*C(:,2) + A(:,3).*C(:,3)).* ...
       (A(:,1).*B(:,1) + A(:,2).*B(:,2) + A(:,3).*B(:,3));
    angles(:,j) = atan2(y,x); 
end
ind = find(angles<0);
angles(ind) = angles(ind) + 2*pi;
par_area = sum(angles')' - pi;
par_area = par_area/(4*pi);

% total_area = sum(par_area);
% if (abs(total_area-4*pi)>10^(-3))
%     disp(sprintf('  ***** Problem: Total area %f *****',total_area));
% end

return;
