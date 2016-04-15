% first order surrogate signal
function S = c2getSOrder1(surrogate_signal)

S = [surrogate_signal  ones(size(surrogate_signal))];
    
end