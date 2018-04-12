function K = gradDescent(target,tolerance)
    terms = 10;
    [K, cost] = makeNewK(terms);

    clf(figure(1))
    hold on
    i = 1;
    while cost > tolerance
        stepMatrix = eye(terms)/1000;
        grad = arrayfun(@(p) cost - objFun(K + stepMatrix(p,:)), 1:terms);
        K = K + 100 * grad ;
        cost = objFun(K);
        plot(i,cost,'.')
        drawnow
        if (i == 2 && cost > .2); [K,cost] = makeNewK(terms); i = 1; end
        i = i+1;
    end 
        
    function cost = objFun(M)
        [~,~,~,cost] = runOde(M,target);
    end

    function [K, cost] = makeNewK(terms)
        K = [rand(1,terms/2),rand(1,terms/2)*5];
        cost = objFun(K); 
    end
end