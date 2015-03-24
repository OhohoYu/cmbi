function c5()

addpath NIFTI_20110921

limits=[66,76;
        55,65;
        44,54;
        34,43;
        23,33];
    
COUCH_POS = 5;
CPGS = 40;

[cp_disp, surrogate_signal, ~, ~] = load_data(COUCH_POS, CPGS);

MODELS = 3;
POINTS = 5;

couch_indices = [30,40,33,1,3;
                 30,40,28,1,3;
                 30,40,23,1,3;
                 30,45,18,1,3;
                 30,45,13,1,3];

% two_sigma_lin(point, param_nr, min-max)
two_sigma_lin = zeros(POINTS, 2, 2);               
conf_95_lin = zeros(POINTS, 2, 2);

two_sigma_2poly = zeros(POINTS, 3, 2);               
conf_95_2poly = zeros(POINTS, 3, 2);

two_sigma_3poly = zeros(POINTS, 4, 2);               
conf_95_3poly = zeros(POINTS, 4, 2);

doPlotFig = 0; % set to 1 if you want to plot figure with samples and uncertainty

functions = {@c2getSOrder1, @c2getSOrder2, @c2getSOrder3};

%% linear model
for c=1:POINTS  
  specific_cp_disp = cp_disp(c,:,couch_indices(c,1),couch_indices(c,2),couch_indices(c,3),couch_indices(c,4),couch_indices(c,5));
  parameter_sample = MCMC(specific_cp_disp, surrogate_signal(c,:), functions{1});
  %plot(parameter_sample(:,1))
  plotLines(parameter_sample, specific_cp_disp, surrogate_signal(c,:), functions{1});
  [h, two_sigma_lin(c,1,:), conf_95_lin(c,1,:)] = c5calcUncertainty(parameter_sample(:,1), doPlotFig);
  [h, two_sigma_lin(c,2,:), conf_95_lin(c,2,:)] = c5calcUncertainty(parameter_sample(:,2), doPlotFig);
end

%% 2nd order polynomial model
for c=1:POINTS  
  specific_cp_disp = cp_disp(c,:,couch_indices(c,1),couch_indices(c,2),couch_indices(c,3),couch_indices(c,4),couch_indices(c,5));
  parameter_sample = MCMC(specific_cp_disp, surrogate_signal(c,:), functions{2});
  %plot(parameter_sample(:,1))
  plotLines(parameter_sample, specific_cp_disp, surrogate_signal(c,:), functions{2});
  [h, two_sigma_2poly(c,1,:), conf_95_2poly(c,1,:)] = c5calcUncertainty(parameter_sample(:,1), doPlotFig);
  [h, two_sigma_2poly(c,2,:), conf_95_2poly(c,2,:)] = c5calcUncertainty(parameter_sample(:,2), doPlotFig);
  [h, two_sigma_2poly(c,3,:), conf_95_2poly(c,3,:)] = c5calcUncertainty(parameter_sample(:,3), doPlotFig);
end

%% 3rd order polynomial model
for c=1:POINTS  
  specific_cp_disp = cp_disp(c,:,couch_indices(c,1),couch_indices(c,2),couch_indices(c,3),couch_indices(c,4),couch_indices(c,5));
  parameter_sample = MCMC(specific_cp_disp, surrogate_signal(c,:), functions{3});
  %plot(parameter_sample(:,1))
  plotLines(parameter_sample, specific_cp_disp, surrogate_signal(c,:), functions{3});
  [h, two_sigma_3poly(c,1,:), conf_95_3poly(c,1,:)] = c5calcUncertainty(parameter_sample(:,1), doPlotFig);
  [h, two_sigma_3poly(c,2,:), conf_95_3poly(c,2,:)] = c5calcUncertainty(parameter_sample(:,2), doPlotFig);
  [h, two_sigma_3poly(c,3,:), conf_95_3poly(c,3,:)] = c5calcUncertainty(parameter_sample(:,3), doPlotFig);
  [h, two_sigma_3poly(c,4,:), conf_95_3poly(c,4,:)] = c5calcUncertainty(parameter_sample(:,4), doPlotFig);
end

save('MCMC.mat', 'two_sigma_lin', 'two_sigma_2poly', 'two_sigma_3poly', 'conf_95_lin', 'conf_95_2poly', 'conf_95_3poly');

end

function samples = MCMC(cp_disp, surrogate_signal, func)
% cp_disp is for one voxel
% surrogate signal is for the couch position where the voxel lies
% func can be linear, 1st of 2nd order polynomial
% CPGS is the number of control point grids/ timepoints


[params, SSD] = fit1Vox(surrogate_signal, cp_disp, func);

NR_SAMPLES = 10000;
samples = zeros(NR_SAMPLES, length(params));

covQ = eye(length(params));
% covQ(1,1) = 1;
% covQ(2,2) = 1;
% covQ(3,3) = 1;
covQ = covQ / 10;


acceptanceCount = 0;

paramsOld = params;
ssd_old = SSDfromParams(surrogate_signal, cp_disp, func, params);
sigmaNoise = 0.5 * ssd_old/length(cp_disp); % estimate the measurement noise from the initial SSD

for t=1:NR_SAMPLES
  paramsNew = mvnrnd(paramsOld, covQ)'; % sample new data point
  ssd_new = SSDfromParams(surrogate_signal, cp_disp, func, paramsNew);
  a = (ssd_old - ssd_new)/(2*sigmaNoise^2); % calc acceptance ratio
  if (a > log(rand))
    % accept the sample
    samples(t,:) = paramsNew';
    ssd_old = ssd_new;
    acceptanceCount = acceptanceCount + 1;
    paramsOld = paramsNew;
  else
    % reject the sample
    samples(t,:) = paramsOld';
  end

  
end

acc_rate = acceptanceCount / NR_SAMPLES

end

function [params, SSD] = fit1Vox(surrogate_signal, cp_disp, orderFunc)

S = orderFunc(surrogate_signal');
params = pinv(S' * S)*S'*cp_disp';
Dpred = S*params;

SSD = sum((Dpred - cp_disp').^2);

end

function SSD = SSDfromParams(surrogate_signal, cp_disp, orderFunc, params)

S = orderFunc(surrogate_signal');
Dpred = S*params;

SSD = sum((Dpred - cp_disp').^2);

end

function plotLines(parameter_sample, specific_cp_disp, surrogate_signal, orderFunc)

indices = 1000:1000:10000;

figure
scatter(surrogate_signal, specific_cp_disp);

for i=indices
    S = orderFunc(surrogate_signal');
    Dpred = S*parameter_sample(i,:)';
    
    [sorted_surrog, indices_sort_surrog] = sort(surrogate_signal);

    hold on
    plot(sorted_surrog, Dpred(indices_sort_surrog));
end

end