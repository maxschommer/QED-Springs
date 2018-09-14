% clear all
% load('StateInfo5M_T')

n = 22;

target = States(n,:)
[T,X,~,cost,idx] =  runOde(-Ks(n,:),target,'time',25);

clf(figure(1))
hold on
title(cost)
plot(T,X(:, 6:10))
plot(T(idx),target,'kx')