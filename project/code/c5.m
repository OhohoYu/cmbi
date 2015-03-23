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
               
ranges = zeros(MODELS, POINTS);               

functions = [@c2getSOrder1, @c2getSOrder2, @c2getSOrder3 ];

for m=1:MODELS
  for c=1:POINTS  
    specific_cp_disp = cp_disp(c,:,couch_indices(c,1),couch_indices(c,2),couch_indices(c,3),couch_indices(c,4),couch_indices(c,5));
    ranges(m,p) = MCMC(specific_cp_disp, surrogate_signal(c,:), functions(m));
  end
end

end

function MCMC(cp_disp, surrogate_signal, func, CPGS)



[params, SSD] = fit1Vox(surrogate_signal, cp_disp,CPGS,COUCH_POS, func);

NR_SAMPLES = 10000;
covQ = eye(length(params));
covQ(1,1) = 1;
covQ(2,2) = 1;
covQ(3,3) = 1;

sigmaNoise = 0.1;
acceptanceCount = 0;

paramsOld = params;
ssd_old = SSDfromParams(surrogate_signal, cp_disp, func, params);
for t=1:NR_SAMPLES
  paramsNew = mvnrnd(paramsOld, covQ); % sample new data point
  ssd_new = SSDfromParams(surrogate_signal, cp_disp, func, paramsNew);
  a = (ssd_old - ssd_new)/(2*sigmaNoise^2); % calc acceptance ratio
  if (a > log(rand))
    % accept the sample
    samples(:,t) = paramsNew(1:3);
    ssd_old = ssd_new;
    acceptanceCount = acceptanceCount + 1;
    paramsOld = paramsNew;
  else
    % reject the sample
    samples(:,t) = paramsOld(1:3);
  end

  
end

acc_rate = acceptanceCount / NR_SAMPLES;



end

function [params, SSD] = fit1Vox(surrogate_signal, cp_disp, orderFunc)

S = orderFunc(surrogate_signal');
params = pinv(S' * S)*S'*cp_disp';
Dpred = S*params;

SSD = sum((Dpred - cp_disp).^2);

end

function SSD = SSDfromParams(surrogate_signal, cp_disp, orderFunc, params)

S = orderFunc(surrogate_signal');
Dpred = S*params;

SSD = sum((Dpred - cp_disp).^2);

end