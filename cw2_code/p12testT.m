function p12testT()

%% a
SAMPLE_SIZE = 25;
MU0 = 1;
MU1 = 1.5;
MUError = 0;
STD_DEV = 0.25;

% set seed for random generator
rng(1);
tvals = zeros(100,1);
tvals2 = zeros(100,1);
for i=1:100

  % compute the new Y
  Y0 = MU0 + MUError + STD_DEV .* randn(SAMPLE_SIZE, 1);
  Y1 = MU1 + MUError + STD_DEV .* randn(SAMPLE_SIZE, 1);

  Y = [Y0;Y1];

  Ycentered = Y - mean(Y);

  % apply t-test, H should be 1
  [H,P,CI,STATS] = ttest(Y0, Y1);
  [H,P,CI,STATS2] = ttest2(Y0, Y1);
  
  tvals(i) = STATS.tstat;
  tvals2(i) = STATS2.tstat;
  
end
end