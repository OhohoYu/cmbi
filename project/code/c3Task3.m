function c3Task3()

addpath NIFTI_20110921

full_vol = load_nii('../data/4DCT_ref_lungs.nii');
Dpred = load('c3CrossValidD3.mat');
[COUCH, ~, X, Y, Z, T, D] = size(Dpred.Dpred3);
clear Dpred
MODELS = 3;
CPG_INCOMPL = 10; % only 10 out of 40 CT scans are provided
land_error = zeros(MODELS, COUCH, CPG_INCOMPL);

land_error_orig_reg = zeros(COUCH, CPG_INCOMPL);

for m=1:3
  m = 3;
  dpred_var_name = sprintf('Dpred%d',m );
  data_file_name = sprintf('c3CrossValidD%d.mat', m);
  Dpred = load(data_file_name);
  Dpred = Dpred.(dpred_var_name);

  for couch=1:COUCH
    couch
    landmark_file = sprintf('../data/Anatomical_landmarks/landmarks_couch_pos%d.mat', couch);
    landmarks = load(landmark_file);
    
    for cpg=1:CPG_INCOMPL
      
      trans_landmark = transPointsWithCPG(Dpred(couch, cpg,:,:,:,:,:), landmarks(cpg,:))
      land_error(m,couch, cpg) = sqrt(sum((trans_landmark - ref_landmarks).^2));
    end
  end

  clear Dpred
end

save('def_field_error.mat', 'error_mean', 'error_std_dev');

end
