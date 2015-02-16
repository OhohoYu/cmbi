function y = NoddiSimpleTrans(x)
y(1) = x(1)^2; %S0
y(2) = x(2)^2; % d
y(3) = q1Trans(x(3)); % f
y(4) = x(4); % theta
y(5) = x(5); % phi
y(6) = x(6)^2; % k

end