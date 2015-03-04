function [tstats, pVal] = calcTperm(Y0, Y1, X, C, dimX)

origTval = calcT(X, [Y0; Y1], C, dimX);
tic
SAMPLE_SIZE0 = length(Y0);
SAMPLE_SIZE1 = length(Y1);

D = [Y0; Y1];

indices = 1:SAMPLE_SIZE0+SAMPLE_SIZE1;

I1 = combnk(indices, SAMPLE_SIZE0);
NR_PERMS = size(I1,1);
I2 = zeros(NR_PERMS,SAMPLE_SIZE1);
tstats = zeros(NR_PERMS, 1);

D1 = D(I1);
M = X*pinv(X'*X)*X';
ImM = (eye(size(M)) - M);
[n, ~] = size(X);
invXX = pinv(X'*X);

for i=1:NR_PERMS
  I2(i,:) = setdiff(indices, I1(i,:));
  D2 = D(I2(i,:));
  %[~, ~, ~, STATS]= ttest2(D1(i,:), D2);
  %tstats(i) = STATS.tstat;
  
  Y = [D1(i,:)'; D2];
  %tstats(i) = calcT(X, Y, C, dimX);
  %t = calcT(X, Y, C, dimX);

  betaHat = pinv(X'*X)*X' * Y;
  eHat = ImM * Y;
  variance = eHat'*eHat/(n - dimX);
  Sb = variance * invXX;
  tstats(i)  = (C' * betaHat)/sqrt(C' * Sb * C);
  
  %assert(t == tstats(i) );
  
end

pVal = nnz(tstats > origTval)/NR_PERMS;

toc 
end