clc
clear all
% data = cleanData(csvread('output.csv'));

figure(1)
% plot(data(:,1),data(:,2:end))

[T,X] = runOde([1,0],zeros(1,10),'init',[-1,zeros(1,9)]);
plot(T,X(:,6:10))

