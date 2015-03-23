function c3Task3()

addpath NIFTI_20110921

nii_file = sprintf('../data/%dpos_data_couch/reg_couch_pos%d_cine%.2d_cpg.nii',1,1,1);
nii_template = load_nii(nii_file);
Dpred = load('c3CrossValidD3.mat');
[COUCH, CPG, X, Y, Z, T, D] = size(Dpred.Dpred3);
clear Dpred
MODELS = 3;
CPG_INCOMPL = 10; % only 10 out of 40 CT scans are provided
land_error = zeros(MODELS, COUCH, CPG_INCOMPL);

land_error_orig_reg = zeros(COUCH, CPG_INCOMPL);

for couch=1:COUCH
  couch
  landmark_file = sprintf('../data/Anatomical_landmarks/landmarks_couch_pos%d.mat', couch);
  load(landmark_file);

  for cpg=1:CPG

    reg_filename = sprintf('../data/%dpos_data_couch/reg_couch_pos%d_cine%.2d_cpg.nii',couch,couch,cpg-1);
    reg_cp = load_nii(reg_filename);

    if (~isnan(cine_landmarks(cpg,1)))
      trans_landmark_reg = transPointsWithCPG(reg_cp, cine_landmarks(cpg,:));
      land_error_orig_reg(couch, cpg) = pdist([trans_landmark_reg; ref_landmarks]);
    else
      land_error_orig_reg(couch, cpg) = NaN;
    end
    
    
  end
end

for m=1:3
  dpred_var_name = sprintf('Dpred%d',m );
  data_file_name = sprintf('c3CrossValidD%d.mat', m);
  Dpred = load(data_file_name);
  Dpred = Dpred.(dpred_var_name);

  for couch=1:COUCH
    couch
    landmark_file = sprintf('../data/Anatomical_landmarks/landmarks_couch_pos%d.mat', couch);
    load(landmark_file);
    
    for cpg=1:CPG
      nii_template.img = reshape(Dpred(couch, cpg,:,:,:,:,:), [X, Y,Z,T,D]);
      
      if (~isnan(cine_landmarks(cpg,1)))
        trans_landmark_model = transPointsWithCPG(nii_template, cine_landmarks(cpg,:));
        land_error(m,couch, cpg) = pdist([trans_landmark_model; ref_landmarks]);
      else
        land_error(m,couch, cpg) = NaN;
      end
      
    end
  end

  clear Dpred
end



save('landmark_errors.mat', 'land_error', 'land_error_orig_reg');

end
