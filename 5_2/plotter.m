clc
stateInfo = load('StateInfo5MSing');
Ks = stateInfo.Ks;
States = stateInfo.States;

diff = 1.01;
% data = cleanData(csvread('output.csv'));
K = Ks(5, :);

K(length(K)/2+1:end) = K(length(K)/2+1:end)*diff;

% for diff = linspace(1,2.84,200)
%     cla
%     

    [T,X, drive, cost, idx] = runOde(K,States(5, :),'time',25, 'natFreq', 1.4);
    T(idx)
    cost
    clf(figure(1))

    for mass = 1:5
    %     subplot(5,1,mass)
        hold on
    %     plot(data(:,1),data(:,mass+1),'k')
        plot(T,X(:,mass+5)*20,'r')    
    end
    pause(.01)
% end

