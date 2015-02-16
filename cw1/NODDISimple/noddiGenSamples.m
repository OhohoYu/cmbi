function noddiGenSamples()

[~, bvals, qhat] = q13preprocessing();

NR_MEASUREMENTS = length(qhat);
NR_SAMPLES = 20000;

n_samples = RandSampleSphere(NR_SAMPLES,'uniform');
n_samples3MS = repmat(n_samples, [1 1 NR_MEASUREMENTS]);
qhat3MS = repmat(qhat, [1 1 NR_SAMPLES]);
n_samples3MS = permute(n_samples3MS,[2 3 1]);
qDotNSquaredMS = squeeze(sum(qhat3MS .* n_samples3MS, 1).^2);
bvalsMS = repmat(bvals, [NR_SAMPLES 1])';

save('samples20k.mat','n_samples', 'bvalsMS', 'qDotNSquaredMS');
%save('expBDQN2k.mat', 'expBDQN');

end