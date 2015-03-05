function unitTest()

SAMPLE_SIZE = 8;
MU0 = 1;
MU1 = 1.5;
MUError = 0;
STD_DEV = 0.25;


X = [repmat([1 0], SAMPLE_SIZE,1); repmat([0 1], SAMPLE_SIZE,1)];

C = [1; -1];
dimX = 2;

for i=1:10
    i
    Y0 = MU0 + MUError + STD_DEV .* randn(SAMPLE_SIZE, 1);
    Y1 = MU1 + MUError + STD_DEV .* randn(SAMPLE_SIZE, 1);
    
    tic
    ans1 = calcTperm(Y0, Y1, X, C, dimX);
    toc
    
    tic
    ans2 = calcTpermVect(Y0, Y1, X, C, dimX);
    toc
    
    assert(sum(abs(ans1 - ans2)) < 0.000000001);

end



end