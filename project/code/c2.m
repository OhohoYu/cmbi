function c2()

addpath NIFTI_20110921

limits=[66,76;
        55,65;
        44,54;
        34,43;
        23,33];
    
COUCH_POS = 5;
CPGS = 40;

[cp_disp, surrogate_signal, surrogate_phase, surrogate_gradient] = load_data(COUCH_POS, CPGS);

% fit the linear model for one voxel

% fit just the given voxels for each couch position, plots the data
%params1 = fit1Vox(surrogate_signal, cp_disp,CPGS,COUCH_POS, @c2getSOrder1);
%params2 = fit1Vox(surrogate_signal, cp_disp,CPGS,COUCH_POS, @c2getSOrder2);
%params3 = fit1Vox(surrogate_signal, cp_disp,CPGS,COUCH_POS, @c2getSOrder3);


params7 = fit1VoxAdvBspl(surrogate_signal, surrogate_phase, cp_disp,CPGS,COUCH_POS, @advGetSBspline);
%params8 = fit1VoxAdv2D(surrogate_signal, surrogate_gradient, cp_disp,CPGS,COUCH_POS, @advGetS2Dlinear);
%params9 = fit1VoxAdv2D(surrogate_signal, surrogate_gradient, cp_disp,CPGS,COUCH_POS, @advGetS2Dpoly2);



%save('c2params_couch1.mat', 'params1', 'params2', 'params3');

% fits all the voxels for every couch position using 1st order model
%c2fitAllVoxFast(surrogate_signal, cp_disp, @c2getSOrder1);

% same but for second order
%c2fitAllVoxFast(surrogate_signal, cp_disp, @c2getSOrder2);

% same but for third order
%c2fitAllVoxFast(surrogate_signal, cp_disp, @c2getSOrder3);

end

function C = fit1Vox(surrogate_signal, cp_disp,CPGS,COUCH_POS, orderFunc)
couch_indices = [30,40,33,1,3;
                 30,40,28,1,3;
                 30,40,23,1,3;
                 30,45,18,1,3;
                 30,45,13,1,3];
             
%params = zeros(COUCH_POS, )             
cp_disp_vox = zeros(COUCH_POS, CPGS);
for c=1:1%COUCH_POS
    cp_disp_vox(c,:) = cp_disp(c,:,couch_indices(c,1),couch_indices(c,2),couch_indices(c,3),couch_indices(c,4),couch_indices(c,5));
    
    S = orderFunc(surrogate_signal(c,:)');
    C = pinv(S' * S)*S'*cp_disp_vox(c,:)';
    Dpred = S*C;
    
    [sorted_surrog, indices_sort_surrog] = sort(surrogate_signal(c,:));
    figure
    scatter(surrogate_signal(c,:), cp_disp_vox(c,:));
    hold on
    plot(sorted_surrog, Dpred(indices_sort_surrog));
end
           
end

function C = fit1VoxAdv2D(surrogate_signal, surrogate_aux, cp_disp,CPGS,COUCH_POS, orderFunc)
couch_indices = [30,40,33,1,3;
                 30,40,28,1,3;
                 30,40,23,1,3;
                 30,45,18,1,3;
                 30,45,13,1,3];
             
%params = zeros(COUCH_POS, )             
cp_disp_vox = zeros(COUCH_POS, CPGS);
for c=1:1%COUCH_POS
    cp_disp_vox(c,:) = cp_disp(c,:,couch_indices(c,1),couch_indices(c,2),couch_indices(c,3),couch_indices(c,4),couch_indices(c,5));
    
    S = orderFunc(surrogate_signal(c,:)', surrogate_aux(c,:)');
    C = pinv(S' * S)*S'*cp_disp_vox(c,:)';
    Dpred = S*C;
    
    C
    [sorted_surrog, indices_sort_surrog] = sort(surrogate_signal(c,:));
    figure
    scatter(surrogate_signal(c,:), cp_disp_vox(c,:));
    hold on
    plot(sorted_surrog, Dpred(indices_sort_surrog));
end
           
end


function C = fit1VoxAdvBspl(surrogate_signal, surrogate_aux, cp_disp,CPGS,COUCH_POS, orderFunc)
couch_indices = [30,40,33,1,3;
                 30,40,28,1,3;
                 30,40,23,1,3;
                 30,45,18,1,3;
                 30,45,13,1,3];
             
%params = zeros(COUCH_POS, )             
cp_disp_vox = zeros(COUCH_POS, CPGS);
for c=1:1%COUCH_POS
    cp_disp_vox(c,:) = cp_disp(c,:,couch_indices(c,1),couch_indices(c,2),couch_indices(c,3),couch_indices(c,4),couch_indices(c,5));
    
    S = orderFunc(surrogate_aux(c,:)');
    C = pinv(S' * S)*S'*cp_disp_vox(c,:)';
    Dpred = S*C;
    
    [sorted_surrog, indices_sort_surrog] = sort(surrogate_signal(c,:));
    figure
    scatter(surrogate_signal(c,:), cp_disp_vox(c,:));
    hold on
    plot(sorted_surrog, Dpred(indices_sort_surrog));
end
           
end









