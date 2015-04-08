function [Dpred] = c3CrossValidSepPhase(surrogate_signal, surrogate_phase, cp_disp, orderFunc)
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
    
      Sall = orderFunc(surrogate_signal(couch,:)');  % surrogate signals (inputs)
      
      PhaseAll = surrogate_phase(couch,:);
      Phase = PhaseAll(indices);
      S = Sall(indices,:);
      
      S1 = S(Phase < 0.5,:);
      S2 = S(Phase >= 0.5,:);
      
      invSSS1 = pinv(S1' * S1)*S1';
      invSSS2 = pinv(S2' * S2)*S2';
      
      disp = squeeze(cp_dispCSA(couch,indices,:));
      
      
      params1 = invSSS1 * disp(Phase < 0.5,:);
      params2 = invSSS2 * disp(Phase >= 0.5,:);
      
      if (PhaseAll(i) < 0.5)
        DpredA = Sall(i,:) * params1;
      else
        DpredA = Sall(i,:) * params2;
      end
      
      Dpred(couch,i,:,:,:,:,:) = reshape(DpredA, [Xsize, Ysize, Zsize,1, Dsize]);
                

      
    end
    


end

end