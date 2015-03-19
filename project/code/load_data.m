function [cp_disp, surrogate_signal, surrogate_phase, surrogate_gradient] = load_data(COUCH_POS, CPGS)

cp_disp = zeros(COUCH_POS,CPGS,88,68,41,1,3);
surrogate_signal = zeros(COUCH_POS,40);
surrogate_phase = zeros(COUCH_POS,40);
surrogate_gradient = zeros(COUCH_POS,40);

% read the surrogate data and the control point displacements
for c=1:COUCH_POS
    surrogate_file = sprintf('../data/Respiratory_surrogate_data/resp_surr_couch_pos%d.mat', c);
    matdata = load(surrogate_file);
    surrogate_signal(c,:) = matdata.signal';
    surrogate_phase(c,:) = matdata.phase';
    surrogate_gradient(c,:) = matdata.gradient';
    
    for cpg=0:CPGS-1
        cp_filename = sprintf('../data/%dpos_data_couch/reg_couch_pos%d_cine%.2d_cpg.nii',c,c,cpg);
        cp = load_nii(cp_filename);
        cp_disp(c,cpg+1,:,:,:,:,:) = cp.img;
    end
end

end