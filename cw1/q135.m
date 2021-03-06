function q135()

addpath ZeppelinTwoStick
addpath BallTwoStick
addpath NODDISimple

%for running ZeppTwoStick see ZeppelinTwoStick/ZeppelinTwoStickUnc

%[paramsZeppTwoStick, SSDZeppTwoStick] = ZeppTwoStickUnc();

%[paramsBallTwoStick, SSDBallTwoStick] = BallTwoStickUnc();

%[paramsNoddiZepp, SSDNoddiZepp] = NoddiZeppUnc();


[signals, bvals, qhat] = q13preprocessing();

sigma = 0.04;
K = length(signals);

% aicBallStick =calcAIC(5, K, SSDDBallStick)
% bicBallStick =calcBIC(5, K, SSDDBallStick)
% 
% % Zeppelin-Stick
% load('q132ZeppStickUnc.mat');
% aicZeppStick =calcAIC(7, K, SSDZeppStick)
% bicZeppStick =calcBIC(7, K, SSDZeppStick)
% 
% % Zeppelin-Stick with tortuosity
% load('q132ZeppStickTortUnc.mat');
% aicZeppStickTort =calcAIC(6, K, SSDZeppStickTort)
% bicZeppStickTort =calcBIC(6, K, SSDZeppStickTort)


% assuming sigma is known

% Zeppelin-Stick
load('q132ZeppStickUnc.mat');
aicZeppStick =calcAICSigma(7, SSDZeppStick, sigma)
bicZeppStick =calcBICSigma(7, K, SSDZeppStick, sigma)

% BallTwoStick
load('BallTwoStick/BallTwoStick.mat');
aicBallTwoStick =calcAICSigma(8, SSDBallTwoStick, sigma)
bicBallTwoStick =calcBICSigma(8, K, SSDBallTwoStick, sigma)

% ZeppTwoStick
load('ZeppelinTwoStick/ZeppTwoStick.mat');
aicZeppTwoStick =calcAICSigma(8, SSDZeppTwoStick, sigma)
bicZeppTwoStick =calcBICSigma(8, K, SSDZeppTwoStick, sigma)

% Ball-Watson
load('NoddiSimple.mat');
aicNoddiSimple =calcAICSigma(6, SSDNoddiSimple, sigma)
bicNoddiSimple =calcBICSigma(6, K, SSDNoddiSimple, sigma)

% Zeppelin-Watson
load('NoddiZepp.mat');
aicNoddiZepp =calcAICSigma(8, SSDNoddiZepp, sigma)
bicNoddiZepp =calcBICSigma(8, K, SSDNoddiZepp, sigma)



end

function aic = calcAIC(N, K, SSD)
% N is the nr of parameters 
% K is the number of data points
aic = 2*N + K*log(SSD/K);
end

function bic = calcBIC(N, K, SSD)
% N is the nr of parameters 
% K is the number of data points
bic = N*log(K) + K*log(SSD/K);
end

function aic = calcAICSigma(N, SSD, sigma)
% N is the nr of parameters 
% sigma is the std deviation
aic = 2*N + SSD/(sigma^2);
end

function aic = calcBICSigma(N, K, SSD, sigma)
% N is the nr of parameters 
% K is the number of data points
% sigma is the std deviation
aic = N*log(K) + SSD/(sigma^2);
end

