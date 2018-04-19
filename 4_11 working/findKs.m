clear all
numMasses = 3;
numSolutions = 1; % For each state, the number of solutions to explore for 
                  % minimizing the derivative of the solution.

for targetNum = 0:1:(2^(numMasses-1)-1)     
    biV = de2bi(targetNum, numMasses);
    biV(biV==0)=-1;
    statesM(targetNum+1, :) = cat(2, zeros(1, numMasses), biV);
end
statesM(1,:)

f = waitbar( 0, ['Loading ' int2str(0) ' ...']);
for i = 1:size(statesM)
    maxDiffKs = Inf(1);
    
    for j = 1:numSolutions
        waitbar( j/(2*numSolutions), f, ['Loading ' int2str(i) ' ...'])
        K_pot = gradDescent(statesM(i,:),'tolerance', .005, 'time', 25, ...
            'maxIters', 100, 'numExplorations', 100);
        [T,X,drive,~,idx] = runOde(K_pot,statesM(i,:));
        Ks(i, :) = K_pot;
        Y = max(diff(drive)/(T(2)-T(1)));
        if Y < maxDiffKs
            Ks(i,:) = K_pot;
            maxDiffKs = Y;
        end
    end
end

Ks = cat(1, Ks, flipud(-1*Ks));
States = cat(1, statesM, flipud(-1*statesM));
save('StateInfo3M','Ks', 'States')

clf(figure(1))
hold on
for i = 1:size(statesM)
    [T,X,drive,~,idx] = runOde(Ks(i,:),statesM(i,:));
    plot(T-T(idx),X(:,4:6)) 
    
end
