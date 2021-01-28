% ============================================
% utl_signmatrix
%
% Goal: create signmatrix
% max_d is max degree
%
% Li Shen 
% 01/14/2007 - create

function utl_sgm(max_d)
global sgm;

for d=1:max_d
    n = 2*d+1;
    M = (-1).^(1:n^2);
    sgm{d} = reshape(M,n,n);
end
   
return;
