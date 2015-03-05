function [pVal, tThresh] = calcTpermVect(Y0, Y1, X, C, dimX, I1, I2)
format long 

origTval = calcT(X, [Y1; Y0], C, dimX);
%tic


D = [Y0; Y1];


NR_PERMS = size(I1,1);
%I2 = zeros(NR_PERMS,SAMPLE_SIZE1);

D1 = D(I1);
M = X*pinv(X'*X)*X';
ImM = (eye(size(M)) - M);
[n, ~] = size(X);
invXX = pinv(X'*X);
invXX_X = pinv(X'*X)*X';

%indicesPS = repmat(indices, NR_PERMS, 1);

%I2 = arrayfun(setdiff, indicesPS, I1, 'UniformOutput', true)

%applyToGivenRow = @(func, matrix1, matrix2) @(row) func(matrix1(row, :), matrix2(row, :));
%applyToRows = @(func, matrix1, matrix2) arrayfun(applyToGivenRow(func, matrix1, matrix2), 1:size(matrix1,1))'

% Example
%myMx = [1 2 3; 4 5 6; 7 8 9];
%myFunc = @sum;

%I2 = applyToRows(@setdiff, indicesPS, I1);

%I22 = arrayfun(@(i) setdiff(indicesPS(i,:),I1(i,:)),1:size(indicesPS,1))';




D2 = D(I2);
YPS = [D1, D2];
betaHat2P = invXX_X * YPS';
eHatSP = ImM * YPS';
varianceP = sum(eHatSP .* eHatSP,1)'/(n - dimX);
invXXP22 = permute(repmat(invXX,[1,1,NR_PERMS]),[3 1 2]);
varianceP22 = repmat(varianceP, [1, 2, 2]);
Sb2P2 = permute(varianceP22 .* invXXP22, [2, 1, 3]);
%SbP22 = varianceP22 .* invXXP22;

tstatsP  = (C' * betaHat2P) ./ sqrt(C' * [squeeze(Sb2P2(1,:,:))*C, squeeze(Sb2P2(2,:,:))*C]');


pVal = nnz(tstatsP > origTval)/NR_PERMS;

%  d
sortedTstats = sort(tstatsP);
tThresh = sortedTstats(floor(NR_PERMS * 95/100));

%toc 
end