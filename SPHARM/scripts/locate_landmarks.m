function landmarks = locate_landmarks(theta, phi, landmarks)
% locate landmarks like center of east/west hemisphere, north/south pole

disp(sprintf('North Pole : %05d (%f, %f) pi',landmarks(1),0,-0.5));
disp(sprintf('South Pole : %05d (%f, %f) pi',landmarks(2),0,0.5));

values = phi.^2 + (theta+pi/2).^2;
[value, east] = min(values);
landmarks(3) = east; % center of east hemisphere
%disp(sprintf('East Center: %05d (%f, %f) pi',east,theta(east)/pi,phi(east)/pi));

values = phi.^2 + (theta-pi/2).^2;
[value, west] = min(values);
landmarks(4) = west; % center of west hemisphere
%disp(sprintf('West Center: %05d (%f, %f) pi',west,theta(west)/pi,phi(west)/pi));

return;
