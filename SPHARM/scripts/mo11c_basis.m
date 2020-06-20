% ============================================
% mo11c_basis.m
%
% Goal: Create canonical spherical harmonic bases
%
% Li Shen 
% 04/11/2002 - create
% 10/15/2002 - rename and modify

function Z = mo11c_basis(vs, degree)

[PHI,THETA] = cart2sph(vs(:,1),vs(:,2),vs(:,3));
nPHI = PHI;
ind = find(nPHI<0);
nPHI(ind) = nPHI(ind)+2*pi;
% nPHI = PHI+pi;
nTHETA = pi/2-THETA;
vertnum = length(THETA);

Z = spharm_basis(degree,nTHETA,nPHI); 

return;

% %
% % calculate the spherical harmonic functions
% % do not use 'i'
% %
% 
% function Z = spharm_basis(max_degree,theta,phi)
% 
% Z = [];
% 
% for n = 0:max_degree
% 
% 	% P = legendre(n,X) computes the associated Legendre functions of degree n and 
% 	% order m = 0,1,...,n, evaluated at X. Argument n must be a scalar integer 
% 	% less than 256, and X must contain real values in the domain -1<=x<=1.
% 	% The returned array P has one more dimension than X, and each element
% 	% P(m+1,d1,d2...) contains the associated Legendre function of degree n and order
% 	% m evaluated at X(d1,d2...).
% 
%     Pn = legendre(n,cos(theta))';
%     
%     posi_Y = [];
%     nega_Y = [];
%     
%     for m= 0:n
%         v = sqrt(((2*n+1)/(4*pi))*(factorial(n-m)/factorial(n+m)));
%         v = v*Pn(:,m+1);
%         v = v.*exp(i*m*phi);
%         posi_Y(:,m+1) = v; % positive order;
%         nega_Y(:,n-m+1) = (-1)^(m)*conj(v); % negative order
%     end
%     
%     Z(:,end+1:end+n) = nega_Y(:,1:n);
%     Z(:,end+1:end+n+1) = posi_Y(:,1:(n+1));
% end
% 
% return;

%
% calculate the spherical harmonic functions
% do not use 'i'
%

function Z = spharm_basis(max_degree,theta,phi)

Z = []; vnum = length(theta);

% save calculations for efficiency
for k = 0:(2*max_degree)
    fact(k+1) = factorial(k);
end
for m = 0:max_degree
    exp_i_m_phi(:,m+1) = exp(i*m*phi);
    sign_m(m+1) = (-1)^(m);
end

for n = 0:max_degree

	% P = legendre(n,X) computes the associated Legendre functions of degree n and 
	% order m = 0,1,...,n, evaluated at X. Argument n must be a scalar integer 
	% less than 256, and X must contain real values in the domain -1<=x<=1.
	% The returned array P has one more dimension than X, and each element
	% P(m+1,d1,d2...) contains the associated Legendre function of degree n and order
	% m evaluated at X(d1,d2...).

    Pn = legendre(n,cos(theta'))';
    
    posi_Y = [];
    nega_Y = [];
    
    m= 0:n;
    v = sqrt(((2*n+1)/(4*pi))*(fact(n-m+1)./fact(n+m+1)));
    v = v(ones(1,vnum),:).*Pn(:,m+1).*exp_i_m_phi(:,m+1);
    posi_Y(:,m+1) = v; % positive order;
    nega_Y(:,n-m+1) = sign_m(ones(1,vnum),m+1).*conj(v); % negative order
    
    Z(:,end+1:end+n) = nega_Y(:,1:n);
    Z(:,end+1:end+n+1) = posi_Y(:,1:(n+1));
end

return;

