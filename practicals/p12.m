function p12()

scores = [10,2; 5,4;1,4; 6,2;7,4;3,5;4,4;5,5;1,6;8,4];
X = scores(:,1);
Y = scores(:,2);

nr_observ = size(scores,1);
%plotVarSub(scores)

mu = mean(scores);

scoresCentered = scores - repmat(mu, nr_observ,1);

%plotVarSub(scoresCentered)

% 1.4
stdDev = std(scoresCentered)
len = sum(scoresCentered .^ 2);

(stdDev .^2 ) * (nr_observ - 1)

Xcent = scoresCentered(:,1);
Ycent = scoresCentered(:,2);


% 1.5
cor = corr(scoresCentered(:,1), scoresCentered(:,2))
cosAng = dot(Xcent, Ycent)/(norm(Xcent)*norm(Ycent));

% 2.4
b = regress(Ycent,Xcent)
pred = Xcent*b;
error = sum((pred - Ycent).^2)

scatter(Xcent,Ycent)
hold on
plot(Xcent,pred)
hold on
scatter(Xcent,pred)

Xlen = norm(Xcent);
Ylen = norm(Ycent);

lenRatio = Ylen/Xlen

% b/cor == lenRatio
end

function plotVarSub(scores)

% var space
scatter(scores(:,1), scores(:,2));

% subject space
h = figure
scatter3(scores(1,:), scores(2,:),scores(3,:));

end