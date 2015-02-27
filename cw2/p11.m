function p11()
%% a
SAMPLE_SIZE = 25;
MU0 = 1;
MU1 = 1.5;
MUError = 0;
STD_DEV = 0.25;

% set seed for random generator
rng(1);

% compute the new Y
Y0 = MU0 + MUError + STD_DEV .* randn(SAMPLE_SIZE, 1);
Y1 = MU1 + MUError + STD_DEV .* randn(SAMPLE_SIZE, 1);

% estimate the new means
muEst0 = mean(Y0);
muEst1 = mean(Y1);

% estimate the new std deviations
stdDevEst0 = std(Y0);
stdDevEst1 = std(Y1);

% check that they are close to the true values
tol = 0.1;
assert(abs(muEst0 - MU0) < tol);
assert(abs(muEst1 - MU1) < tol);
assert(abs(stdDevEst0 - STD_DEV) < tol);
assert(abs(stdDevEst1 - STD_DEV) < tol);

%% b

% apply t-test, H should be 1
[H,P,CI,STATS] = ttest2(Y0, Y1);

% null should be rejected, the samples come from different distributions
assert(H == 1); 

%% c 

% build matrices X and Y
X = [repmat([1 0], SAMPLE_SIZE,1); repmat([0 1], SAMPLE_SIZE,1)];

Y = [Y0;Y1];

partC(SAMPLE_SIZE, X, Y)

end

function partC(SAMPLE_SIZE, X, Y)

% i 
M = X*inv(X'*X)*X';




end