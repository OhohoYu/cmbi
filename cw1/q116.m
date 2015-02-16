function q116(dwis, qhat, bvals)

[dwis, qhat, bvals] = q1Preprocessing();

Avox = dwis(:,52,62,25);

% Define a starting point for the non-linear fit
startx = [1.1e+05 1.5e-03 0.5 0 0];

lb = [0  , 0  , 0, -inf, -inf];
ub = [inf, inf, 1,  inf,  inf]; 
fmincon_options = optimset('MaxFunEvals', 20000, 'Algorithm', 'interior-point',...
    'TolX', 1e-10, 'TolFun', 1e-10, 'Display', 'off');

sigma = eye(5);
sigma(1,1) = 1000;
sigma(2,2) = 0.001;
sigma(3,3) = 1;
sigma(4,4) = pi;
sigma(5,5) = pi;
globTol = 0.1;
nr_iterations = 100;
model = 'BallStickSSD';
tic
[parameter_hat, RESNOM, minCounter] = fitVoxGlobConGeneric(Avox, qhat, bvals, nr_iterations, startx,lb, ub,sigma,globTol, fmincon_options,model);
toc


end
