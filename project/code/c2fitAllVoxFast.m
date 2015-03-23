function [Dpred, params] = c2fitAllVoxFast(surrogate_signal, cp_disp, orderFunc)
% vectorised version - fits all voxels in the 7D CPG arrays

[COUCH_POS,CPGS,Xsize, Ysize, Zsize, ~ , Dsize] = size(cp_disp);

% couch x signals x all
cp_dispCSA = reshape(cp_disp, [COUCH_POS CPGS Xsize*Ysize*Zsize*Dsize]);

DpredSA = zeros(CPGS, [Xsize*Ysize*Zsize*Dsize]);
Dpred = zeros(COUCH_POS,CPGS,Xsize, Ysize, Zsize,1, Dsize);

for couch=1:COUCH_POS
    
    signals = orderFunc(surrogate_signal(couch,:)');  % surrogate signals (inputs)
    invSSS = pinv(signals' * signals)*signals';
    
    params = invSSS * squeeze(cp_dispCSA(couch,:,:));
    DpredSA = signals * params;
    Dpred(couch,:,:,:,:,:,:) = reshape(DpredSA, [CPGS,Xsize, Ysize, Zsize,1, Dsize]);
    
end

end