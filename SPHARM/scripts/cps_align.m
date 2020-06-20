% ============================================
% cps_align.m 
%
% Goal: Align P to X, where P and X are two corresponding point sets
%
% Li Shen 
% 11/02/2006 - create

function [P,M] = cps_align(P,X)

M = eye(4);

for k = 1 : length(P)
  dist = (X(:,1)-P(k,1)).^2 + (X(:,2)-P(k,2)).^2 + (X(:,3)-P(k,3)).^2;
  [val,ind] = min(dist);
  closest(k) = ind;
end
Xc = X;

muP   = mean(P);
muXc  = mean(Xc);
N     = length(P);
sig   = zeros(3);
for k = 1 : N
  sig = sig + (P(k,:)' * Xc(k,:));
end
sig   = sig/N;
sig   = sig - (muP' * muXc); % cross-covariance matrix
A     = sig - sig';
delta = [A(2,3) ; A(3,1) ; A(1,2)];
Q     = [trace(sig)  delta' ; delta  sig+sig'-trace(sig)*eye(3)];
[V,D] = eig(Q);
[val,ind] = max(diag(D));
qR    = V(:,ind); % optimal rotation
q0    = qR(1);
q1    = qR(2);
q2    = qR(3);
q3    = qR(4);
R     = [q0^2+q1^2-q2^2-q3^2  2*(q1*q2 - q0*q3)  2*(q1*q3 + q0*q2) ; ...
    2*(q1*q2 + q0*q3)  q0^2+q2^2-q1^2-q3^2  2*(q2*q3 - q0*q1) ; ...
    2*(q1*q3 - q0*q2) 2*(q2*q3 + q0*q1)  q0^2+q3^2-q1^2-q2^2];
qT    = muXc' - R*muP'; % optimal translation

Pnew  = (R*P')';
diff  = mean( sum(((Pnew - P).^2)') );
P = Pnew;

P(:,1) = P(:,1) + qT(1);
P(:,2) = P(:,2) + qT(2);
P(:,3) = P(:,3) + qT(3);

Mr = eye(4); Mr(1:3,1:3) = R;
Mt = eye(4); Mt(1:3,4) = qT(1:3);
M = Mt*Mr*M;
return;

%
% Rotate around x, y, z (counterclockwise when looking towards the origin)
%

function R = rotmat(x, y, z)

Rx = [      1       0       0; ...
            0  cos(x) -sin(x); ...
            0  sin(x)  cos(x)];

Ry = [ cos(y)       0  sin(y); ...
            0       1       0; ...
      -sin(y)       0  cos(y)];

Rz = [ cos(z) -sin(z)       0; ...
       sin(z)  cos(z)       0; ...
            0      0        1];

R = Rz*Ry*Rx;
return;
