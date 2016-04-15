function advCheckFit()

addpath NIFTI_20110921

limits=[66,76;
        55,65;
        44,54;
        34,43;
        23,33];
    
COUCH_POS = 5;
CPGS = 40;

[cp_disp, surrogate_signal, surrogate_phase, surrogate_gradient] = load_data(COUCH_POS, CPGS);


m = 7;
filename = sprintf('c3CrossValidD%d.mat', m);
load(filename);

% problems with models 7&9

%var_name = sprintf('Dpred%d', m);
couch = 1;
DpredTest = squeeze(Dpred7(couch, :, 30,30,33,1,3));
[sorted_surrog, indices_sort_surrog] = sort(surrogate_signal(couch,:));
figure
scatter(surrogate_signal(couch,:), squeeze(cp_disp(couch,:, 30,40,33,1,3)));
hold on
plot(sorted_surrog, DpredTest(indices_sort_surrog));

end