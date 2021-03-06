clear all
numMasses = 5;
numSolutions = 1; % For each state, the number of solutions to explore for 
                  % minimizing the derivative of the solution.

for targetNum = 0:1:(2^(numMasses-1)-1)     
    biV = de2bi(targetNum, numMasses);
    biV(biV==0)=-1;
    statesM(targetNum+1, :) = cat(2, zeros(1, numMasses), biV);
end


% statesM(1,:)
% size(statesM)
% States = cat(1, statesM, flipud(-1*statesM))
% pause(90)
% f = waitbar( 0, ['Loading ' int2str(0) ' ...']);

parfor i = 1:2^(numMasses-1)
    maxDiffKs = Inf(1);

    for j = 1:numSolutions
%         waitbar( j/(2*numSolutions), f, ['Loading ' int2str(i) ' ...'])
        K_pot = gradDescent(statesM(i,:),'tolerance', 1, 'time', 25, ...
            'maxIters', 100, 'numExplorations', 100, 'terms', 24);
        [T,X,drive,~,idx] = runOde(K_pot,statesM(i,:));
        Ks(i, :) = K_pot;
        Y = max(diff(drive)/(T(2)-T(1)));
        if Y < maxDiffKs
            Ks(i,:) = K_pot;
            maxDiffKs = Y;
        end
    end
end
S = size(Ks);
L = S(2);
revKs = Ks;
revKs(:, 1:L/2)= -revKs(:, 1:L/2); % This is the proper reveral of Ks,
                                   % just the amplitudes being flipped
Ks = cat(1, Ks, flipud(revKs));

States = cat(1, statesM, flipud(-1*statesM));
save('StateInfo5M_3','Ks', 'States')
