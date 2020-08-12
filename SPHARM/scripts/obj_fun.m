function f = obj_fun(vs)
% Computes the objective function
% Hopefully fast, but need edges information
% 
global edges;

f = -sum(sum(vs(edges(:,1),1:3).*vs(edges(:,2),1:3)));

return;
