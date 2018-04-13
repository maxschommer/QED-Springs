function [kWorking, error,t,X,idx,K] = gradDescent()
    numMasses = 3;
    kWorking = [];
    for targetNum = 0:1:(2^numMasses-1)
        
        biV = de2bi(targetNum, numMasses);
        biV(biV==0)=-1;
        target = [biV(1),biV(2),biV(3),0,0,0]
        
        terms = 20;
        randomExplore = 1000;

        clf(figure(1))
        hold on
        
        while 1
            restart = 0;
            [K, cost] = makeNewK(terms);

            
            
            minimalK = K;
            minimalCost = cost;
            for i = [1:1:randomExplore] 
                [K, cost] = makeNewK(terms);
                if cost < minimalCost
                    minimalCost = cost;
                    minimalK = K;
                end
            end
            K = minimalK;
            cost = minimalCost;

            i = 1;

            while cost > .01 && restart == 0

                stepMatrix = eye(terms)/1000;
                grad = arrayfun(@(p) cost - objFun(K + stepMatrix(p,:)), 1:terms);
                K = K + 20 * grad ;
                cost = objFun(K);
                plot(i,cost,'.')
                drawnow
                i = i+1;
                if i > 100
                    restart= 1;
                end
            end

            if restart == 0
                kWorking(:, targetNum+1) = K'
                break
            end
        end  
        [error,t,X,idx] = howClose(K(1:terms/2),K(terms/2+1:end),target,true);
    end
    
    csvwrite('output.csv', kWorking)
    
    function cost = objFun(M)
        cutoff = length(M)/2;
        cost = howClose(M(1:cutoff),M(cutoff+1:end),target,false);
    end

    function [K, cost] = makeNewK(terms)
        K = [rand(1,terms/2),rand(1,terms/2)*5]; 
        cost = objFun(K); 
    end
end