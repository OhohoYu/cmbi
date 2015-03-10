function t = calcT(X, Y, C, dimX)

M = X*pinv(X'*X)*X';

betaHat = pinv(X'*X)*X' * Y;

eHat = (eye(size(M)) - M) * Y;
[n, ~] = size(X);
variance = eHat'*eHat/(n - dimX);
Sb = variance * pinv(X'*X);


t = (C' * betaHat)/sqrt(C' * Sb * C);

end