function [paramsNoddiZepp, SSDNoddiZepp] = NoddiZeppUncFindK()

addpath ../
format long

[signals, bvals, qhat] = q13preprocessing();

[logS0, D, SSDDiffTensor] = q1FitVoxLin(signals, qhat, bvals);
[EigVect,EigVals] = eig(D); 

EigVals = diag(EigVals);
sortedEigs = sort(EigVals);

% S0 = 1;
% d = 1e-09;
% f = 0.34;
% theta = 4.68;
% phi = 3.166;
% k = 0.5;

%S0 = 0.923198831;
%d = 0.0000000011;
%f = 0.4994217943;
%theta = 4.7046867;
%phi = 0.03849512;
%lam1 = 0;
%lam2 = 0;
k = 10;

%params_orig = [S0, d, f, theta, phi, lam1, lam2, k];
load('../q132ZeppStickUnc.mat')
params_orig([1,2,3,4,5,7,8]) = paramsZeppStick;
params_orig(6) = k;


global n_samples
global bvalsMS
global qDotNSquaredMS



load('samples20k.mat');
%load('expBDQN20k.mat');

%load('NoddiZepp.mat');
%params_orig = paramsNoddiZepp;
tic
[ orig_ssd, predictedNoddi ]= NoddiZeppSSD(params_orig, signals, bvals, qhat);
toc
%[ orig_ssd2, predictedNodd2 ]= NoddiZeppSSD(params_orig, signals, bvals, qhat);
%[ orig_ssd3, predictedNodd3 ]= NoddiZeppSSD(params_orig, signals, bvals, qhat);

%h = eyeball(signals, predictedNoddi, bvals, qhat);
%orig_ssd
%orig_ssd2
%mean(abs(predictedNoddi - predictedNodd2))

%predictedBallStick = BallStick(params_orig, bvals, qhat);
minSSD = inf;
minK = inf;
parsNewK = params_orig;
valuesK = 10:0.1:15;
N = length(valuesK);
ssds = zeros(N,1);
for i=1:N
  i
  parsNewK(6) = valuesK(i);
  [ ssds(i), ~ ]= NoddiZeppSSD(parsNewK, signals, bvals, qhat);
end
[minSSD, minI] = min(ssds);
minK = valuesK(minI);

end