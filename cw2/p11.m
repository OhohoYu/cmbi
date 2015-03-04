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

C = [1; -1];
dimXc = 2; % it is not 3, as I had it before

t = calcT(X, Y, C, dimXc);

% M = calcAll(X, Y, C, dimXc)

% % xi
% betaTrue = [1; 1.5];
% 
% eTrue = Y - X*betaTrue;
% % projection of e onto C(X)
% eX = M * eTrue;
% % xii
% % projection of e onto error space
% eE = (eye(size(M)) - M) * eTrue;

%% d

% X = 3x50, column space dim(X) = 2
X = [repmat([1 1 0], SAMPLE_SIZE,1); repmat([1 0 1], SAMPLE_SIZE,1)];

C = [0; 1; -1];
dimXd = 2;
%calcAll(X, Y, C, dimXd);

%% e

%  X = 2x50, column space dim(X) = 2
X = [repmat([1 1], SAMPLE_SIZE,1); repmat([1 0], SAMPLE_SIZE,1)];

C = [0; 1];
dimXe = 2;
calcAll(X, Y, C, dimXe);



end


