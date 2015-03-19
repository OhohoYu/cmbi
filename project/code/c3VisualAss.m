function c3VisualAss()

addpath NIFTI_20110921


full_vol = load_nii('../data/4DCT_ref_lungs.nii');
%for m=1:3
  
  Dpred = load('c3CrossValidD3.mat');
  Dpred = Dpred.Dpred3;
  
  couch = 1; cpg = 10;
  cp_filename = sprintf('../data/%dpos_data_couch/reg_couch_pos%d_cine%.2d_cpg.nii',couch,couch,cpg);
  cp = load_nii(cp_filename);
  
  trans_nii = cp;
  trans_nii.img = squeeze(Dpred(couch, cpg,:,:,:,:,:));
  
  
  figure(1)
  dispNiiSliceColourOverlay(cp, trans_nii, 'z', 70);
  
  clear Dpred
%end

end