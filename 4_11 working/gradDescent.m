function K = gradDescent(target,tolerance)
    terms = 10;
    [K, cost] = makeNewK(terms);
    i = 1;
    
    while cost > tolerance
        stepMatrix = eye(terms)/1000;
        grad = arrayfun(@(p) cost - objFun(K + stepMatrix(p,:)), 1:terms);
        K = K + 30 * grad ;
        cost = objFun(K);
        i = i+1;
        
        if (cost > exp(-i/20)/10+tolerance)
            [K,cost] = makeNewK(terms); i = 1; 
        end
    end 
    
    function cost = objFun(M)
        [~,~,~,cost] = runOde(M,target);
    end

    function [K, cost] = makeNewK(terms)
        K = [rand(1,terms/2),rand(1,terms/2)*5];
        cost = objFun(K); 
    end
end