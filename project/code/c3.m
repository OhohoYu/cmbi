function c3()

addpath NIFTI_20110921

limits=[66,76;
        55,65;
        44,54;
        34,43;
        23,33];
    
COUCH_POS = 5;
CPGS = 40;

[cp_disp, surrogate_signal, ~, ~] = load_data(COUCH_POS, CPGS);


% perform leave-one out coss-validation
Dpred = zeros(CPGS, COUCH_POS,CPGS-1,Xsize, Ysize, Zsize,1, Dsize);
for i=1:CPGS
    i
    indices = [1:i-1 i+1:CPGS];
    surrogate_signal_round = surrogate_signal(:,indices);
    cp_disp_round = cp_disp(:,indices,:,:,:,:,:);

    % fits all the voxels for every couch position using all 3 models
    %c2fitAllVoxFast(surrogate_signal, cp_disp, @c2getSOrder1);
    %c2fitAllVoxFast(surrogate_signal, cp_disp, @c2getSOrder2);
    Dpred(i,:,:,:,:,:,:,:) = c2fitAllVoxFast(surrogate_signal_round, cp_disp_round, @c2getSOrder3);
end

for c=[2,5] % 1:COUCH_POS
    for cpg=0:CPGS-1
        cp_filename = sprintf('../data/%dpos_data_couch/reg_couch_pos%d_cine%.2d_cpg.nii',c,c,cpg);
        cp = load_nii(cp_filename);
        cp_disp(c,cpg+1,:,:,:,:,:) = cp.img;
    end
end

%show 3 images 
end

