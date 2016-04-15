% third order surrogate signal
function S = advGetSBspline(surrogate_phase)

N = 4; % nr of control points to optimise
assert(N >= 4);
delta = 1/N;
k = floor(surrogate_phase / delta) - 1;
j = surrogate_phase / delta - floor(surrogate_phase / delta);

NR_TIMEPOINTS = size(surrogate_phase,1);

S = zeros(NR_TIMEPOINTS, N);

for t=1:NR_TIMEPOINTS
  knIndices = [mod(k(t), N), mod(k(t)+1, N), mod(k(t)+2, N), mod(k(t)+3,N)]; 
  S(t,knIndices + 1) = [Bspline0(j(t)) Bspline1(j(t)) Bspline2(j(t)) Bspline3(j(t))];
end

end

function x = Bspline0(u)
x = (1-u)^3/6;
end

function x = Bspline1(u)
x = (3*u^3-6*u^2+4)/6;
end

function x = Bspline2(u)
x = (-3*u^3+3*u^2+3*u+1)/6;
end

function x = Bspline3(u)
x = (u^3)/6;
end