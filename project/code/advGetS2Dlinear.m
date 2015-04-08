function S = advGetS2Dlinear(surrogate_signal, surrogate_gradient)

S = [surrogate_signal surrogate_gradient ones(size(surrogate_signal))];
    
end