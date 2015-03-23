function c3Task2()

addpath NIFTI_20110921

full_vol = load_nii('../data/4DCT_ref_lungs.nii');
Dpred = load('c3CrossValidD3.mat');
[COUCH, ~, X, Y, Z, T, D] = size(Dpred.Dpred3);
clear Dpred
MODELS = 3;
CPG_INCOMPL = 10; % only 10 out of 40 CT scans are provided
error_mean = zeros(MODELS, COUCH, CPG_INCOMPL);
error_std_dev = zeros(MODELS, COUCH, CPG_INCOMPL);
SSD = zeros(MODELS, COUCH, CPG_INCOMPL);
nr_data_points = zeros(MODELS, COUCH, CPG_INCOMPL);

for m=1:3
  dpred_var_name = sprintf('Dpred%d',m );
  data_file_name = sprintf('c3CrossValidD%d.mat', m);
  Dpred = load(data_file_name);
  Dpred = Dpred.(dpred_var_name);

  for couch=1:COUCH
    couch
    for cpg=1:CPG_INCOMPL
      

      reg_filename = sprintf('../data/%dpos_data_couch/reg_couch_pos%d_cine%.2d_cpg.nii',couch,couch,cpg-1);
      reg_cp = load_nii(reg_filename);

      trans_nii = reg_cp;
      trans_nii.img = reshape(Dpred(couch, cpg,:,:,:,:,:), [ X, Y, Z, T, D]);

      [~, def_field_trans, ~] = deformNiiWithCPG(trans_nii,full_vol,full_vol);
      [~, def_field_reg, ~] = deformNiiWithCPG(reg_cp,full_vol,full_vol);

      cine_ct_filename = sprintf('../data/%dpos_data_couch/ct_couch_pos%d_cine%.2d.nii',couch,couch,cpg-1);
      cine_ct = load_nii(cine_ct_filename);
      cine_ct = cine_ct.img ~= -1;
      [CineX, CineY, CineZ] = size(cine_ct);

      diff = sqrt(sum((def_field_trans.img - def_field_reg.img).^2 ,5));

      diff = diff .* cine_ct; % filter all the voxels outside the lungs

      diff_vect = reshape(diff, [CineX CineY CineZ]); % only count non-zlero elements 
      diff_vect = diff_vect(diff_vect ~= 0);
      error_mean(m,couch, cpg) = mean(diff_vect);
      error_std_dev(m,couch,cpg) = std(diff_vect);
      
      SSD_temp = diff_vect.^2;
      SSD(m, couch,cpg) = sum(SSD_temp(:));
      nr_data_points(m ,couch, cpg) = length(SSD_temp);
      
    end
  end

  clear Dpred
end

save('def_field_error.mat', 'error_mean', 'error_std_dev', 'SSD', 'nr_data_points');

end
