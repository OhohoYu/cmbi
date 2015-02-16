function [sumRes, S] = NoddiSimpleSSD(x, Avox, bvals, qhat)

% Extract the parameters
S0 = x(1);
diff = x(2);
f = x(3);
theta = x(4);
phi = x(5);
k = x(6);
%lam1 = x(7);
%lam2 = x(8);

% Synthesize the signals
mu = [cos(phi)*sin(theta) sin(phi)*sin(theta) cos(theta)];

NR_MEASUREMENTS = length(qhat);
NR_SAMPLES = 20000;


% tic
% SIsamples = zeros(NR_SAMPLES, NR_MEASUREMENTS);
% for sample_nr=1:NR_SAMPLES
%   n = n_samples(sample_nr,:);
%   qDotNSquared = (sum(qhat .* repmat(n, [NR_MEASUREMENTS 1])')).^2;
%   SIsamples(sample_nr,:) = watson(k,n,mu)*exp(-bvals * diff .*  qDotNSquared); % intra-cellular diffusion
% end
% Si = mean(SIsamples); % multiply by the surface of the sphere
% toc

% n_samples = RandSampleSphere(NR_SAMPLES,'uniform');
% n_samples3MS = repmat(n_samples, [1 1 NR_MEASUREMENTS]);
% qhat3MS = repmat(qhat, [1 1 NR_SAMPLES]);
% n_samples3MS = permute(n_samples3MS,[2 3 1]);
% qDotNSquaredMS = squeeze(sum(qhat3MS .* n_samples3MS, 1).^2);
% bvalsMS = repmat(bvals, [NR_SAMPLES 1])';
global n_samples
global bvalsMS
global qDotNSquaredMS

expBDQN = exp(-(bvalsMS * diff) .*  qDotNSquaredMS);
watsonMS = repmat(watson(k,n_samples,mu), [1 NR_MEASUREMENTS])';
SIsamplesMS =  watsonMS .* expBDQN;
Si = mean(SIsamplesMS,2)';



%Se = exp(-bvals.*(lam2 + (lam1 - lam2)*muDotNSquared)); % extra-cellular diffusion
Se = exp(-bvals*diff); % extra-cellular diffusion

S = S0*(f*Si +(1-f)*Se);

% Compute the sum of squared differences
sumRes = sum((Avox - S').^2);

end



