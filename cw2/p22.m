function p22()

RES = 40;
SUBJECTS = 8;
CPAdata = zeros(SUBJECTS, RES, RES, RES);
PPAdata = zeros(SUBJECTS, RES, RES, RES);

cpaI = [4,5,6,7,8,9,10,11];
ppaI = [3,6,9,10,13,14,15,16];

for s=1:SUBJECTS
  filename = sprintf('glm/CPA%d_diffeo_fa.img', cpaI(s));
  fid = fopen(filename, 'r', 'l'); % little-endian
  data = fread(fid, 'float'); % 16-bit floating point
  CPAdata(s,:,:,:) = reshape(data, [40 40 40]); % dimension 40x40x40
  
  filename = sprintf('glm/PPA%d_diffeo_fa.img', ppaI(s));
  fid = fopen(filename, 'r', 'l'); % little-endian
  data = fread(fid, 'float'); % 16-bit floating point
  PPAdata(s,:,:,:) = reshape(data, [40 40 40]); % dimension 40x40x40
end

fid = fopen('glm/wm_mask.img', 'r', 'l'); % little-endian
data = fread(fid, 'float'); % 16-bit floating point
wm_mask = reshape(data, [40 40 40]); % dimension 40x40x40

% a
%[tVals, maxT] = partA(CPAdata, PPAdata, wm_mask, SUBJECTS, RES);

% b

[pVals, maxP] = partBv2(CPAdata, PPAdata, wm_mask, SUBJECTS, RES);

end

function [tVals, maxT] = partA(CPAdata, PPAdata, wm_mask, SUBJECTS, RES)

X = [repmat([1 0], SUBJECTS,1); repmat([0 1], SUBJECTS,1)];

C = [1; -1];
dimX = 2;

tVals = zeros(RES, RES, RES);
matlabTVals = zeros(RES, RES, RES);
for i=1:RES
  i
  for j=1:RES
    for k=1:RES
      if (wm_mask(i,j,k) == 1)
        tic
        Y = [CPAdata(:,i,j,k); PPAdata(:,i,j,k)];
        tVals(i,j,k) = calcT(X, Y, C, dimX);

        [~,~,~,STATS] = ttest2(CPAdata(:,i,j,k),PPAdata(:,i,j,k));
        matlabTVals(i,j,k) = STATS.tstat;
        assert(abs(tVals(i,j,k) - matlabTVals(i,j,k)) < 0.00001);
        toc
      end
    end
  end
end

save('tVals.mat', 'tVals', 'matlabTVals');

maxT = max(tVals(:));

end

function [pVals, maxP] = partB(CPAdata, PPAdata, wm_mask, SUBJECTS, RES)

%RES = 2;

X = [repmat([1 0], SUBJECTS,1); repmat([0 1], SUBJECTS,1)];

C = [1; -1];
dimX = 2;

pVals = zeros(RES, RES, RES);
tThresh = zeros(RES, RES, RES);
matlabPVals = zeros(RES, RES, RES);

SAMPLE_SIZE0 = 8;
SAMPLE_SIZE1 = 8;

indices = 1:SAMPLE_SIZE0+SAMPLE_SIZE1;

I1 = combnk(indices, SAMPLE_SIZE0);
NR_PERMS = size(I1,1);

I2 = zeros(NR_PERMS,SAMPLE_SIZE1);
for i=1:NR_PERMS
  I2(i,:) = setdiff(indices, I1(i,:));
end


for i=1:RES
  i
  for j=1:RES
    for k=1:RES
      if (wm_mask(i,j,k) == 1)
        %tic
        Y0 = CPAdata(:,i,j,k);
        Y1 = PPAdata(:,i,j,k);
        
        [pVals(i,j,k), tThresh(i,j,k)] = calcTpermVect(Y0, Y1, X, C, dimX, I1, I2);

        [~,matlabPVals(i,j,k)] = ttest2(CPAdata(:,i,j,k),PPAdata(:,i,j,k));
        %toc
      end
    end
  end
end

maxP = max(pVals(:));
save('pValsPerm.mat', 'pVals', 'matlabPVals', 'tThresh', 'maxP');

end


function [maxTs, maxP] = partBv2(CPAdata, PPAdata, wm_mask, SUBJECTS, RES)

%RES = 2;

X = [repmat([1 0], SUBJECTS,1); repmat([0 1], SUBJECTS,1)];

C = [1; -1];
dimX = 2;

SAMPLE_SIZE0 = 8;
SAMPLE_SIZE1 = 8;

indices = 1:SAMPLE_SIZE0+SAMPLE_SIZE1;

% make the permutations
I0 = combnk(indices, SAMPLE_SIZE0);
NR_PERMS = size(I0,1);

I1 = zeros(NR_PERMS,SAMPLE_SIZE1);
for i=1:NR_PERMS
  I1(i,:) = setdiff(indices, I0(i,:));
end

D0 = reshape(CPAdata, [SAMPLE_SIZE0 RES^3])';
D1 = reshape(PPAdata, [SAMPLE_SIZE1 RES^3])';
mask_lin= reshape(wm_mask, [1 RES^3]);

% b
maxTs = zeros(NR_PERMS,1);
for p=1:NR_PERMS
    ind0 = repmat(I0(p,:), [RES^3 1]);
    ind1 = repmat(I1(p,:), [RES^3 1]);
    
    maxTs(p) = calcMaxTImages(D0(ind0), D1(ind1), mask_lin, X, C, dimX);
end

maxTOrig = calcMaxTImages(D0, D1, mask_lin, X, C, dimX);
% c
maxP = nnz(maxTs > maxTOrig)/RES^3;

% d
tThresh = maxTs(floor(RES^3 * 95/100));

save('pValsPerm.mat', 'maxTs', 'maxP', 'tThresh');

end