clear all
load('StateInfo5M_3')

n = 17;

target = States(n,:);
[T,X,~,cost,idx] =  runOde(-Ks(n,:),target,'time',25);

clf(figure(1))
hold on
title(cost)
plot(T,X)
plot(T(idx),target,'kx')