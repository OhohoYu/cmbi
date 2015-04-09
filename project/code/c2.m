function c2()

addpath NIFTI_20110921

limits=[66,76;
        55,65;
        44,54;
        34,43;
        23,33];
    
COUCH_POS = 5;
CPGS = 40;
MODELS = 9;

couch_indices = [30,40,33,1,3;
                 30,40,28,1,3;
                 30,40,23,1,3;
                 30,45,18,1,3;
                 30,45,13,1,3];
               

[cp_disp, surrogate_signal, surrogate_phase, surrogate_gradient] = load_data(COUCH_POS, CPGS);


DpredOrd = zeros(COUCH_POS, CPGS, MODELS);

% fit just the given voxels for each couch position, plots the data
DpredOrd(:,:,1) = fit1Vox(surrogate_signal, cp_disp,CPGS,COUCH_POS, @c2getSOrder1);
DpredOrd(:,:,2) = fit1Vox(surrogate_signal, cp_disp,CPGS,COUCH_POS, @c2getSOrder2);
DpredOrd(:,:,3) = fit1Vox(surrogate_signal, cp_disp,CPGS,COUCH_POS, @c2getSOrder3);

DpredOrd(:,:,4) = fit1VoxAdvSepPhase(surrogate_signal, surrogate_phase, cp_disp,CPGS,COUCH_POS, @c2getSOrder1);
DpredOrd(:,:,5) = fit1VoxAdvSepPhase(surrogate_signal, surrogate_phase, cp_disp,CPGS,COUCH_POS, @c2getSOrder2);
DpredOrd(:,:,6) = fit1VoxAdvSepPhase(surrogate_signal, surrogate_phase, cp_disp,CPGS,COUCH_POS, @c2getSOrder3);

DpredOrd(:,:,7) = fit1VoxAdvBspl(surrogate_signal, surrogate_phase, cp_disp,CPGS,COUCH_POS, @advGetSBspline);
DpredOrd(:,:,8) = fit1VoxAdv2D(surrogate_signal, surrogate_gradient, cp_disp,CPGS,COUCH_POS, @advGetS2Dlinear);
DpredOrd(:,:,9) = fit1VoxAdv2D(surrogate_signal, surrogate_gradient, cp_disp,CPGS,COUCH_POS, @advGetS2Dpoly2);

ROUNDS = 1:3;
round_models = [1:3;4:6;7:9];
legend_names = {{'linear', 'quadratic', 'cubic'}, {'linear - phase separation', ...
  'quadratic - phase separation', 'cubic - phase separation'}, {'B-spline', ...
  '2D linear', '2D quadratic'}};


for c=1:COUCH_POS
  for r=ROUNDS
    cp_disp_vox = cp_disp(c,:,couch_indices(c,1),couch_indices(c,2),couch_indices(c,3),couch_indices(c,4),couch_indices(c,5));
    sorted_surrog = sort(surrogate_signal(c,:));
    h = figure;
    scatter(surrogate_signal(c,:), cp_disp_vox,'filled');
    for m=round_models(r,:)
      hold on
      plot(sorted_surrog, DpredOrd(c,:,m),'LineWidth',1.5);
    end
    xlabel('Surrogate signal');
    ylabel('z - displacement');
    set(gca,'FontSize',19,'FontName','cmr');
    %if c==1
      %set(h_legend,'FontSize',15);
      legend_names_round = legend_names{r};
      h_legend = legend('displacement points', legend_names_round{1}, legend_names_round{2}, legend_names_round{3}, 'Location','northoutside');
      set(h_legend,'Box','off');
    %end

    
    set(h, 'Position', [0 0 600 500]);
    axis tight
    %axis([sorted_surrog(1) sorted_surrog(end) ]);
    figname = sprintf('../report/figures/task2/fit_round%d_couch%d.eps', r,c);
    hgexport(h, figname);
  end
end
  
%save('c2params_couch1.mat', 'params1', 'params2', 'params3');

% fits all the voxels for every couch position using 1st order model
%c2fitAllVoxFast(surrogate_signal, cp_disp, @c2getSOrder1);

% same but for second order
%c2fitAllVoxFast(surrogate_signal, cp_disp, @c2getSOrder2);

% same but for third order
%c2fitAllVoxFast(surrogate_signal, cp_disp, @c2getSOrder3);

end

function DpredOrd = fit1Vox(surrogate_signal, cp_disp,CPGS,COUCH_POS, orderFunc)
couch_indices = [30,40,33,1,3;
                 30,40,28,1,3;
                 30,40,23,1,3;
                 30,45,18,1,3;
                 30,45,13,1,3];
             
cp_disp_vox = zeros(COUCH_POS, CPGS);
DpredOrd = zeros(COUCH_POS, CPGS);
for c=1:COUCH_POS
    cp_disp_vox(c,:) = cp_disp(c,:,couch_indices(c,1),couch_indices(c,2),couch_indices(c,3),couch_indices(c,4),couch_indices(c,5));
    
    S = orderFunc(surrogate_signal(c,:)');
    C = pinv(S' * S)*S'*cp_disp_vox(c,:)';
    Dpred = S*C;
    
    [~, indices_sort_surrog] = sort(surrogate_signal(c,:));
    DpredOrd(c,:) = Dpred(indices_sort_surrog);
end
           
end

function DpredOrd = fit1VoxAdvSepPhase(surrogate_signal, surrogate_phase, cp_disp,CPGS,COUCH_POS, orderFunc)
couch_indices = [30,40,33,1,3;
                 30,40,28,1,3;
                 30,40,23,1,3;
                 30,45,18,1,3;
                 30,45,13,1,3];
             
%params = zeros(COUCH_POS, )             
DpredOrd = zeros(COUCH_POS, CPGS);
Dpred = zeros(COUCH_POS, CPGS);
for c=1:COUCH_POS
    cp_disp_vox = cp_disp(c,:,couch_indices(c,1),couch_indices(c,2),couch_indices(c,3),couch_indices(c,4),couch_indices(c,5));
    
    S = orderFunc(surrogate_signal(c,:)');
    
    Phase = surrogate_phase(c,:);

    S1 = S(Phase < 0.5,:);
    S2 = S(Phase >= 0.5,:);

    invSSS1 = pinv(S1' * S1)*S1';
    invSSS2 = pinv(S2' * S2)*S2';

    params1 = invSSS1 * cp_disp_vox(Phase < 0.5)';
    params2 = invSSS2 * cp_disp_vox(Phase >= 0.5)';
    
    Dpred(c, Phase < 0.5) = S1 * params1;
    Dpred(c, Phase >= 0.5) = S2 * params2;
    
    [~, indices_sort_surrog] = sort(surrogate_signal(c,:));
    DpredOrd(c,:) = Dpred(c, indices_sort_surrog);
end
           
end

function DpredOrd = fit1VoxAdv2D(surrogate_signal, surrogate_aux, cp_disp,CPGS,COUCH_POS, orderFunc)
couch_indices = [30,40,33,1,3;
                 30,40,28,1,3;
                 30,40,23,1,3;
                 30,45,18,1,3;
                 30,45,13,1,3];
             
%params = zeros(COUCH_POS, )             
cp_disp_vox = zeros(COUCH_POS, CPGS);
DpredOrd = zeros(COUCH_POS, CPGS);
for c=1:COUCH_POS
    cp_disp_vox(c,:) = cp_disp(c,:,couch_indices(c,1),couch_indices(c,2),couch_indices(c,3),couch_indices(c,4),couch_indices(c,5));
    
    S = orderFunc(surrogate_signal(c,:)', surrogate_aux(c,:)');
    C = pinv(S' * S)*S'*cp_disp_vox(c,:)';
    Dpred = S*C;
    
    C
    [~, indices_sort_surrog] = sort(surrogate_signal(c,:));
    DpredOrd(c,:) = Dpred(indices_sort_surrog);
%     figure
%     scatter(surrogate_signal(c,:), cp_disp_vox(c,:));
%     hold on
%     plot(sorted_surrog, Dpred(indices_sort_surrog));
end
           
end


function DpredOrd = fit1VoxAdvBspl(surrogate_signal, surrogate_aux, cp_disp,CPGS,COUCH_POS, orderFunc)
couch_indices = [30,40,33,1,3;
                 30,40,28,1,3;
                 30,40,23,1,3;
                 30,45,18,1,3;
                 30,45,13,1,3];
             
%params = zeros(COUCH_POS, )             
cp_disp_vox = zeros(COUCH_POS, CPGS);
DpredOrd = zeros(COUCH_POS, CPGS);
for c=1:COUCH_POS
    cp_disp_vox(c,:) = cp_disp(c,:,couch_indices(c,1),couch_indices(c,2),couch_indices(c,3),couch_indices(c,4),couch_indices(c,5));
    
    S = orderFunc(surrogate_aux(c,:)');
    C = pinv(S' * S)*S'*cp_disp_vox(c,:)';
    Dpred = S*C;
    C
    [~, indices_sort_surrog] = sort(surrogate_signal(c,:));
    DpredOrd(c,:) = Dpred(indices_sort_surrog);
%     figure
%     scatter(surrogate_signal(c,:), cp_disp_vox(c,:));
%     hold on
%     plot(sorted_surrog, Dpred(indices_sort_surrog));
end
           
end









