function c2()

addpath NIFTI_20110921

limits=[66,76;
        55,65;
        44,54;
        34,43;
        23,33];
    
COUCH_POS = 5;
VOLUMES = 10;
CPGS = 40;

couch_indices = [30,40,33,1,3;
                 30,40,28,1,3;
                 30,40,23,1,3;
                 30,45,18,1,3;
                 30,45,13,1,3];

for c=1:COUCH_POS
    for cpg=0:CPGS-1
        ct_filename = sprintf('../data/%dpos_data_couch/ct_couch_pos%d_cine%d.nii',c,c,cpg);
        ct = load_nii(ct_filename);

        figure(1)
        dispNiiSliceColourOverlay(ct, reg1, 'z', slice_nr);
        figure(2)
        dispNiiSliceColourOverlay(ct, reg2, 'z', slice_nr);


    end

end

end