clc

data = cleanData(csvread('output.csv'));

[T,X] = runOde(K,zeros(1,10),'time',25);

clf(figure(1))

for mass = 1:5
    subplot(5,1,mass)
    hold on
    plot(data(:,1),data(:,mass+1),'k')
    plot(T+7.5,X(:,mass+5)*20,'r')    
end


