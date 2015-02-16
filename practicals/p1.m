function p1()

scores = [5,3; 7,2; 4,6];
X = scores(:,1);
Y = scores(:,2);

nr_observ = size(scores,1);
%plotVarSub(scores)

mu = mean(scores);

scoresCentered = scores - repmat(mu, 3,1);

%plotVarSub(scoresCentered)

% 1.4
stdDev = std(scoresCentered)
len = sum(scoresCentered .^ 2)

(stdDev .^2 ) * (nr_observ - 1)

Xcent = scoresCentered(:,1);
Ycent = scoresCentered(:,2);


% 1.5
cor = corr(scoresCentered(:,1), scoresCentered(:,2))
cor2 = corrcoef(scoresCentered(:,1), scoresCentered(:,2))
cosAng = dot(Xcent, Ycent)/(norm(Xcent)*norm(Ycent))
end

function plotVarSub(scores)

% var space
scatter(scores(:,1), scores(:,2));

% subject space
h = figure
scatter3(scores(1,:), scores(2,:),scores(3,:));

end