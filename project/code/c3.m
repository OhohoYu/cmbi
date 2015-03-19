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


%perform leave-one out coss-validation

Dpred1 = c3CrossValid(surrogate_signal, cp_disp, @c2getSOrder1);
save('c3CrossValidD1.mat', 'Dpred1');
clear Dpred1
Dpred2 = c3CrossValid(surrogate_signal, cp_disp, @c2getSOrder2);
save('c3CrossValidD2.mat', 'Dpred2');
clear Dpred2
Dpred3 = c3CrossValid(surrogate_signal, cp_disp, @c2getSOrder3);
save('c3CrossValidD3.mat', 'Dpred3');
clear Dpred3

%show 3 images 
end

