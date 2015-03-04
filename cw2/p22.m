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

[pVals, maxP] = partB(CPAdata, PPAdata, wm_mask, SUBJECTS, RES);

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
        Y = [CPAdata(:,i,j,k); PPAdata(:,i,j,k)];
        tVals(i,j,k) = calcT(X, Y, C, dimX);

        [~,~,~,STATS] = ttest2(CPAdata(:,i,j,k),PPAdata(:,i,j,k));
        matlabTVals(i,j,k) = STATS.tstat;
      end
    end
  end
end

save('tVals.mat', 'tVals', 'matlabTVals');

maxT = max(tVals(:));

end

function [pVals, maxP] = partB(CPAdata, PPAdata, wm_mask, SUBJECTS, RES)

X = [repmat([1 0], SUBJECTS,1); repmat([0 1], SUBJECTS,1)];

C = [1; -1];
dimX = 2;

pVals = zeros(RES, RES, RES);
matlabTVals = zeros(RES, RES, RES);
for i=1:RES
  i
  for j=1:RES
    for k=1:RES
      if (wm_mask(i,j,k) == 1)
        Y0 = CPAdata(:,i,j,k);
        Y1 = PPAdata(:,i,j,k);
        
        [ ~, pVals(i,j,k)] = calcTperm(Y0, Y1, X, C, dimX);

        [~,~,~,STATS] = ttest2(CPAdata(:,i,j,k),PPAdata(:,i,j,k));
        matlabTVals(i,j,k) = STATS.tstat;
      end
    end
  end
end

save('tValsPerm.mat', 'tVals', 'matlabTVals');

maxP = max(pVals(:));

end