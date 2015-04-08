function c3()

addpath NIFTI_20110921

limits=[66,76;
        55,65;
        44,54;
        34,43;
        23,33];
    
COUCH_POS = 5;
CPGS = 40;

[cp_disp, surrogate_signal, surrogate_phase, surrogate_gradient] = load_data(COUCH_POS, CPGS);


%perform leave-one out coss-validation

% Dpred1 = c3CrossValid(surrogate_signal, cp_disp, @c2getSOrder1);
% save('c3CrossValidD1.mat', 'Dpred1');
% clear Dpred1
% Dpred2 = c3CrossValid(surrogate_signal, cp_disp, @c2getSOrder2);
% save('c3CrossValidD2.mat', 'Dpred2');
% clear Dpred2
% Dpred3 = c3CrossValid(surrogate_signal, cp_disp, @c2getSOrder3);
% save('c3CrossValidD3.mat', 'Dpred3');
% clear Dpred3

% Dpred4 = c3CrossValidSepPhase(surrogate_signal, surrogate_phase, cp_disp, @c2getSOrder1);
% save('c3CrossValidD4.mat', 'Dpred4');
% clear Dpred4
% Dpred5 = c3CrossValidSepPhase(surrogate_signal, surrogate_phase, cp_disp, @c2getSOrder2);
% save('c3CrossValidD5.mat', 'Dpred5');
% clear Dpred5
% Dpred6 = c3CrossValidSepPhase(surrogate_signal, surrogate_phase, cp_disp, @c2getSOrder3);
% save('c3CrossValidD6.mat', 'Dpred6');
% clear Dpred6

Dpred7 = c3CrossValid(surrogate_phase, cp_disp, @advGetSBspline);
% save('c3CrossValidD7.mat', 'Dpred7');
clear Dpred7

%Dpred8 = c3CrossValid2D(surrogate_signal, surrogate_gradient, cp_disp, @advGetS2Dlinear);
%save('c3CrossValidD8.mat', 'Dpred8');
%clear Dpred8

%Dpred9 = c3CrossValid2D(surrogate_signal, surrogate_gradient, cp_disp, @advGetS2Dpoly2);
%save('c3CrossValidD9.mat', 'Dpred9');
%clear Dpred9


end

