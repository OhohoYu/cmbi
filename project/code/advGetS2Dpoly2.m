function S = advGetS2Dpoly2(sig, grad)

%S = [ sig.^2 grad.^2 sig.*grad sig grad ones(size(sig))];
S = [ sig.^2 grad.^2 sig.*grad sig grad ones(size(sig))];
    
end