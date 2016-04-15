% second order surrogate signal
function S = c2getSOrder2(surrogate_signal)

S = [surrogate_signal.^2  surrogate_signal  ones(size(surrogate_signal))];
    
end