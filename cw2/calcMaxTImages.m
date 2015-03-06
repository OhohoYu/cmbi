function maxT = calcMaxTImages(D0, D1, wm_mask, X, C, dimX)


NR_PERMS = size(D0, 1);

M = X*pinv(X'*X)*X';
ImM = (eye(size(M)) - M);
[n, ~] = size(X);
invXX = pinv(X'*X);
invXX_X = pinv(X'*X)*X';

% prefixes: P - dimension of pixels/voxels, S - dimension of samples
YPS = [D0, D1];
betaHat2P = invXX_X * YPS';
eHatSP = ImM * YPS';
varianceP = sum(eHatSP .* eHatSP,1)'/(n - dimX);
invXXP22 = permute(repmat(invXX,[1,1,NR_PERMS]),[3 1 2]);
varianceP22 = repmat(varianceP, [1, 2, 2]);
Sb2P2 = permute(varianceP22 .* invXXP22, [2, 1, 3]);
%SbP22 = varianceP22 .* invXXP22;

tstatsP  = (C' * betaHat2P) ./ sqrt(C' * [squeeze(Sb2P2(1,:,:))*C, squeeze(Sb2P2(2,:,:))*C]');

maxT = max(tstatsP .* wm_mask);

% pVal = nnz(tstatsP > origTval)/NR_PERMS;
% 
% %  d
% sortedTstats = sort(tstatsP);
% tThresh = sortedTstats(floor(NR_PERMS * 95/100));

%toc 
end
