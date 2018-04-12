function [error,t,X,F,idx,K] = gradDescent()
    target = [1,-1,1,0,0,0];
    terms = 20;
    [K, cost] = makeNewK(terms);

    clf(figure(1))
    hold on
    i = 1;
    while cost > .01
        stepMatrix = eye(terms)/1000;
        grad = arrayfun(@(p) cost - objFun(K + stepMatrix(p,:)), 1:terms);
        K = K + 10 * grad ;
        cost = objFun(K);
        plot(i,cost,'.')
        drawnow
        if (i == 10 && cost > 1); [K,cost] = makeNewK(terms); i = 1; end
        i = i+1;
    end 
    
    [error,t,X,F, idx] = howClose(K(1:terms/2),K(terms/2+1:end),target,true);
    
    function cost = objFun(M)
        cutoff = length(M)/2;
        cost = howClose(M(1:cutoff),M(cutoff+1:end),target,false);
    end

    function [K, cost] = makeNewK(terms)
        K = [rand(1,terms/2),rand(1,terms/2)*5]; 
        cost = objFun(K); 
    end
end