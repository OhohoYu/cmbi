function c3VisualAss()

addpath NIFTI_20110921

MODELS = 1:9;
axis_limits = [45, 355, 45, 275];

full_vol = load_nii('../data/4DCT_ref_lungs.nii');
for m=MODELS
  
  dpred_var_name = sprintf('Dpred%d',m );
  data_file_name = sprintf('c3CrossValidD%d.mat', m);
  Dpred = load(data_file_name);
  Dpred = Dpred.(dpred_var_name);
  
  [COUCH, CPG, X, Y, Z, T, D] = size(Dpred);
  
  couch = 1; cpg = 1;
  reg_filename = sprintf('../data/%dpos_data_couch/reg_couch_pos%d_cine%.2d_cpg.nii',couch,couch,cpg);
  reg_cp = load_nii(reg_filename);
  
  cine_ct_filename = sprintf('../data/%dpos_data_couch/ct_couch_pos%d_cine%.2d.nii',couch,couch,cpg);
  cine_ct = load_nii(cine_ct_filename);
  
  trans_nii = reg_cp;
  trans_nii.img = reshape(Dpred(couch, cpg,:,:,:,:,:), [ X, Y, Z, T, D]);
  
  [def_vol_nii, def_field_nii, dis_field_nii] = deformNiiWithCPG(trans_nii,full_vol,full_vol);

  h = figure(1);
  dispNiiSliceColourOverlay(cine_ct, def_vol_nii, 'z', 66);
  axis(axis_limits);
  figname = sprintf('../report/figures/task4/visAss_m%d.png', m);
  saveas(h, figname, 'png');
      
  clear Dpred
end

end