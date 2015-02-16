function p2

scores = [10,2; 5,4;1,4; 6,2;7,4;3,5;4,4;5,5;1,6;8,4];
X = scores(:,1);
Y = scores(:,2);
nr_observ = size(scores,1);
%plotVarSub(scores)
mu = mean(scores);
scoresCentered = scores - repmat(mu, nr_observ,1);

%plotVarSub(scoresCentered)
Xcent = scoresCentered(:,1);
Ycent = scoresCentered(:,2);

%1.2

innerProd = X' * X;
outerProd = X * X';

%1.3

Px = outerProd / innerProd;


end