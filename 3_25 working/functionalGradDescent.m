function [error,t,X,idx,kFinal] = gradDescent()
    target = [1,-1,1,0,0,0];
    terms = 20;
    depth = 1000;
    
    K = [rand(1,terms/2),rand(1,terms/2)*5]; %random start values
    cost = objFun(K);
    
    clf(figure(1))
    xlim([0 depth])
    hold on
    
    Grads = zeros(depth,terms);
    
    for i = 1:depth
        stepMatrix = eye(terms)/1000;
        grad = arrayfun(@(p) cost - objFun(K + stepMatrix(p,:)), 1:terms);
        Grads(i,:) = grad;
        K = K + 10 * grad ;
        cost = objFun(K);
        plot(i,cost,'.')
        drawnow
        if cost<.01; break ; end
    end 
    
    title('Error vs Depth')
    kFinal = K;
    
    [error,t,X,idx] = howClose(K(1:terms/2),K(terms/2+1:end),target,cost<.1);
    
    function cost = objFun(M)
        cutoff = length(M)/2;
        cost = howClose(M(1:cutoff),M(cutoff+1:end),target,false);
    end
end