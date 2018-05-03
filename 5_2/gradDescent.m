function K = gradDescent(target,varargin)
    p = inputParser;
    addRequired(p,'target');
    addParameter(p, 'tolerance', .005);
    addParameter(p, 'time', 25);
    addParameter(p, 'maxIters', 600);
    addParameter(p, 'terms', 20);
    addParameter(p, 'numExplorations', 1000);
    parse(p, target, varargin{:});
    maxIters = p.Results.maxIters;
    time = p.Results.time;
    tolerance = p.Results.tolerance;
    terms = p.Results.terms;
    numExplorations = p.Results.numExplorations; %Number of random explorations
    
    kCostMat = randExplore(numExplorations);
    
    exitflag = 0;
    k = 1;
    kLim = 10;
    
    while exitflag == 0
        if k > kLim
            maxIters = maxIters + 500;
            kLim = kLim + 5;
            numExplorations = numExplorations*10;
            kCostMat = randExplore(numExplorations);
            k = 1;
        end
        options = optimset('PlotFcns',@optimplotfval, 'OutputFcn', @outfun, 'MaxIter', maxIters);
        K = kCostMat(k, 2:end);
        k = k+1;
        [K,~,exitflag] = fminsearch(@objFun,K,options);
    end
    
    function kCostMat = randExplore(numExplorations)
        w = waitbar(0, ...
                ['Exploring Random Solutions: ' int2str(0)]);
        kCostMat = zeros(numExplorations, 1+terms);
        for j =1:numExplorations
            waitbar(j/numExplorations, w, ['Exploring Random Solutions: ' int2str(j)]);
            [newK, cost] = makeNewK(terms);        
            kCostMat(j, :) = [cost, newK];
        end
        delete(w)
        kCostMat = sortrows(kCostMat);
    end
    
    function stop = outfun(~, optimValues, ~)
        if optimValues.fval < tolerance
            stop = 1;
        else
            stop = 0;
        end
    end

    function cost = objFun(M)
        [~,~,~,cost] = runOde(M,target,'time' , time);
    end

    function [K, cost] = makeNewK(terms)
        K = [rand(1,terms/2)*5-2.5,rand(1,terms/2)*20];
%         K = rand(1,terms/2)*10-5;
        cost = objFun(K);
    end
end