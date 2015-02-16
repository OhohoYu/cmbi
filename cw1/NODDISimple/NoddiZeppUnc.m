function [paramsNoddiZepp, SSDNoddiZepp] = NoddiZeppUnc()

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
k = 14;

%params_orig = [S0, d, f, theta, phi, lam1, lam2, k];
load('NoddiZepp.mat')
params_orig = paramsNoddiZepp;
%params_orig([1,2,3,4,5,7,8]) = paramsZeppStick;
%params_orig(6) = k;


global n_samples
global bvalsMS
global qDotNSquaredMS

load('samples20k.mat');

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

% Define various options for the non-linear fitting algorithm
h = optimset('MaxFunEvals', 1, 'Algorithm', 'interior-point',...
    'TolX', 1e-5, 'TolFun', 1e-10, 'Display', 'iter');
% S0 d f theta phi

nr_iterations = 0;
globTol = 0.1; % 0.1 recommended

sigmaScale = 0.1;

sigma = eye(5);
sigma(1,1) = 0.15; %S0
sigma(2,2) = 1e-09; %d
sigma(3,3) = 0.1; %f
sigma(4,4) = 2*pi; %theta
sigma(5,5) = 2*pi; %phi
sigma(6,6) = 2; %k
%sigma(9,9) = 1e-09; %lam1
%sigma(10,10) = 1e-09; %lam2

model = 'NoddiZeppTransSSD';
trans = str2func('NoddiZeppTrans');
transInv = str2func('NoddiZeppTransInv');
fminuncOptions = optimoptions(@fminunc,'Algorithm','quasi-newton', 'MaxFunEvals', 20000,'TolX', 1e-10, 'TolFun', 1e-10, 'Display', 'iter'); 

% Now run the fitting
tic
[paramsNoddiZepp, SSDNoddiZepp] = q3fitVoxGlobUnc(signals, qhat, bvals, nr_iterations, params_orig, sigma, fminuncOptions, globTol, model, trans, transInv)
toc
% plots the computation time

[ ~, predictedNoddi ]= NoddiZeppSSD(paramsNoddiZepp, signals, bvals, qhat);
h = eyeball(signals, predictedNoddi, bvals, qhat);

%save('NoddiZepp.mat', 'paramsNoddiZepp', 'SSDNoddiZepp');
% best SSD is 1.24
end