function p12()

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

Y = [Y0;Y1];

% apply t-test, H should be 1
[H,P,CI,STATS] = ttest(Y0, Y1);

% null should be rejected, the samples come from different distributions
assert(H == 1); 

X = [repmat([1 1], SAMPLE_SIZE,1); repmat([1 0], SAMPLE_SIZE,1)];

S = [eye(SAMPLE_SIZE); eye(SAMPLE_SIZE)];

X = [X, S];

C = zeros(SAMPLE_SIZE + 2, 1);
C(2) = 1;

dimX = 26; % because one dimension is lost due to the contrast

[M, t] = calcAll(X, Y, C, dimX)

end