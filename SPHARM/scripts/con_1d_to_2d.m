function [xs, ys] = con_1d_to_2d(is, d)
% convert 1d index to 2d index
%

xs = mod((is-1), d(1))+1;
ys = floor((is-1)/d(1))+1;

return;

