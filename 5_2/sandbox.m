clear all
load('StateInfo5M_3')
ts = [];
ys = [];
for n = 1:32
% n = 22;

    target = States(n,:)
    [T,X,~,cost,idxs(n)] =  runOde(Ks(n,:),target,'time',25);
    times(n) = T(idxs(n));
    res =  moveServos(Ks(n,:), 0, T(idxs(n)), 10, true)
    
end

clf(figure(1))
hold on
title(cost)
plot(T,X(:, 6:10))
plot(T(idxs(12)),target,'kx')

