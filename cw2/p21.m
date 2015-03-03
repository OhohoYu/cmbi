function p21()

%% a
SAMPLE_SIZE0 = 6;
SAMPLE_SIZE1 = 8;
MU0 = 1;
MU1 = 1.5;
MUError = 0;
STD_DEV = 0.25;

% set seed for random generator
rng(1);

% compute the new Y
Y0 = MU0 + MUError + STD_DEV .* randn(SAMPLE_SIZE0, 1);
Y1 = MU1 + MUError + STD_DEV .* randn(SAMPLE_SIZE1, 1);

%% a

% apply t-test, H should be 1
[H,P,CI,STATS] = ttest2(Y0, Y1);

Tval = STATS.tstat
%% b

D = [Y0; Y1];

indices = 1:SAMPLE_SIZE0+SAMPLE_SIZE1;
indRev = indices(end:-1:1)

I1 = combnk(indices, 6);
NR_PERMS = size(I1,1);
I2 = zeros(NR_PERMS,8);
tstats = zeros(NR_PERMS, 1);

D1 = D(I1);

for i=1:NR_PERMS
  I2(i,:) = setdiff(indices, I1(i,:));
  D2 = D(I2(i,:));
  [~, ~, ~, STATS]= ttest2(D1(i,:), D2);
  tstats(i) = STATS.tstat;
end

pVal = nnz(tstats > P)/NR_PERMS;

%% c

meansDiff = mean(Y0) - mean(Y1);



end