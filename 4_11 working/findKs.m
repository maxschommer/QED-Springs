clear all

numSolutions = 10;
states = [0,0,0,-1,-1,-1;
          0,0,0,-1,-1,1;
          0,0,0,-1,1,-1;
          0,0,0,-1,1,1;
          0,0,0,1,-1,-1;
          0,0,0,1,-1,1;
          0,0,0,1,1,-1;
          0,0,0,1,1,1];

size(states)
for i = 1:size(states)-1
    maxDiffKs = Inf(1);
    for j = 1:numSolutions
        clc
        disp(['Loading ' num2str(i) '...'])
        disp(strcat('<', repmat('*', [1, round(40*j/numSolutions)]),  repmat('_', [1, round(40*(numSolutions-j)/numSolutions)]), '>'))
        
        K_pot = gradDescent(states(i,:), 2);
        [T,X,drive,~,idx] = runOde(K_pot,states(i,:));
        Ks(j, i, :) = K_pot;
%         Y = max(diff(drive)/(T(2)-T(1)));
%         if Y < maxDiffKs
%             Ks(i,:) = K_pot;
%             maxDiffKs = Y;
%         end
    end
end



clf(figure(1))
hold on
for i = 1:size(states)-1
    [T,X,drive,~,idx] = runOde(Ks(1, i,:),states(i,:));
    plot(T-T(idx),X(:,4:6)) 
    
end
