function [Dpred] = c2fitAllVoxSlow(surrogate_signal, cp_disp, orderFunc)


[COUCH_POS,CPGS,Xsize, Ysize, Zsize, ~ , Dsize] = size(cp_disp);

Dpred = zeros(COUCH_POS,CPGS,Xsize, Ysize, Zsize,1, Dsize);
for c=1:COUCH_POS
    c
    S = orderFunc(surrogate_signal(c,:)');  % surrogate signals (inputs)
    invSSS = pinv(S' * S)*S';
    for x=1:Xsize
        for y=1:Ysize
            for z=1:Zsize
                for d=1:Dsize

                D = cp_disp(c,:,x,y,z,1,d); % displacements (observations)

                C = invSSS*D'; % model parameters
                Dpred(c,:,x,y,z,1,d) = S*C; % predictions from the model

%                 [sorted_surrog, indices_sort_surrog] = sort(surrogate_signal(c,:));
%                 figure
%                 scatter(surrogate_signal(c,:), D);
%                 hold on
%                 plot(sorted_surrog, Dpred(c,indices_sort_surrog,x,y,z,d));
                
                end
            end
        end
    end
end

end