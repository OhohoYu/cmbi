function [Dpred] = c3CrossValid2D(surrogate_signal, surrogate_aux, cp_disp, orderFunc)
% vectorised version - fits all voxels in the 7D CPG arrays

[COUCH_POS,CPGS,Xsize, Ysize, Zsize, ~ , Dsize] = size(cp_disp);

% q x signals x all
cp_dispCSA = reshape(cp_disp, [COUCH_POS CPGS Xsize*Ysize*Zsize*Dsize]);

DpredA = zeros(1,Xsize*Ysize*Zsize*Dsize);
Dpred = zeros(COUCH_POS,CPGS,Xsize, Ysize, Zsize,1, Dsize);

for i=1:CPGS
    i
    indices = [1:i-1 i+1:CPGS];

    for couch=1:COUCH_POS
    
      Sall = orderFunc(surrogate_signal(couch,:)', surrogate_aux(couch,:)');  % surrogate signals (inputs)
      S = Sall(indices,:);
      invSSS = pinv(S' * S)*S';

      params = invSSS * squeeze(cp_dispCSA(couch,indices,:));
      DpredA = Sall(i,:) * params;
      Dpred(couch,i,:,:,:,:,:) = reshape(DpredA, [Xsize, Ysize, Zsize,1, Dsize]);
                
    end

end



end