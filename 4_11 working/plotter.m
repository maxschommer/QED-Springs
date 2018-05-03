clc
clear all

data = cleanData(csvread('output.csv'));
[T,X] = runOde([1,0],zeros(1,10),'init',[zeros(1,5),-1,0,0,0,0]);

clf(figure(1))
title('Five masses: red = matlab, black = openCV')

for mass = 1:5
    subplot(5,1,mass)
    hold on
    plot(data(:,1),data(:,mass+1),'k')
    plot(T+4.6,X(:,mass+5)*60,'r')
end
