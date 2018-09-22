clear all
load('StateInfo5M_3')
ts = [];
ys = [];
for n = 1:32
    target = States(n,:)
    [T,X,~,cost,idxs(n)] =  runOde(Ks(n,:),target,'time',25);
    times(n) = T(idxs(n));
    res = moveServos(Ks(n,:), 0, T(idxs(n)), 10, true);
    Pos(n, :) = res(2, :);
    Tim(n, :) = res(1, :);
end

clf(figure(1))
hold on
title(cost)
plot(T,X(:, 6:10))
plot(T(idxs(12)),target,'kx')

