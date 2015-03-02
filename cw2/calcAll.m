function [M, t] = calcAll(X, Y, C, dimX)

tol = 0.00001;
% ii 
M = X*pinv(X'*X)*X';

% iii
Yhat = M * Y;

eHat = (eye(size(M)) - M) * Y;

% cosine is almost zero, suggesting the vectors are perpendicular
cosYe = sum(Yhat' * eHat)/(norm(Yhat)*norm(eHat))

assert(abs(cosYe) < tol);

% iv
betaHat = pinv(X'*X)*X' * Y;

% v
[n, ~] = size(X);
variance = eHat'*eHat/(n - dimX);

% vi

Sb = variance * pinv(X'*X)

std1 = sqrt(Sb(1,1));
std2 = sqrt(Sb(2,2));

% vii 
U = null(C');

X0 = X * U;

% viii

M0 = X0*pinv(X0'*X0)*X0';

Yhat0 = M0 * Yhat;
betaHat0 = pinv(X0'*X0)*X0' * Y;

r = 1;

YhatC = norm(Yhat - Yhat0); % additional error 

F = (norm(Yhat - Yhat0)^2 / r) / variance;

% ix
%C = [1; -1]
t = (C' * betaHat)/sqrt(C' * Sb * C);

%assert(abs(t^2 - F) < tol);

end