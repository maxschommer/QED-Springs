clear all

states = [0,0,0,-1,-1,-1;
          0,0,0,-1,-1,1;
          0,0,0,-1,1,-1;
          0,0,0,-1,1,1;
          0,0,0,1,-1,-1;
          0,0,0,1,-1,1;
          0,0,0,1,1,-1;
          0,0,0,1,1,1];
      
for i = 1:7
    disp(['Loading ' num2str(i) '...'])
    Ks(i,:) = gradDescent(states(i,:), .005); 
end

clf(figure(1))
hold on
for i = 1:7
    [T,X,drive,~,idx] = runOde(Ks(i,:),states(i,:));
    plot(T-T(idx),X(:,4:6)) 
    
end


      
