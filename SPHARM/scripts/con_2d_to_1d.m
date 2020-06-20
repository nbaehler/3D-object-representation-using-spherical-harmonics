function is = con_2d_to_1d(xs, ys, d)
% convert 2d index to 1d index
%

is = (ys-1)*d(1) + xs;

return;
