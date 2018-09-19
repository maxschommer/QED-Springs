function [T,X,drive,cost,idx] = runOde(K,target, varargin)
    tSize = size(target);
    numMasses = tSize(2)/2;

    p = inputParser;
    addRequired(p,'K');
    addRequired(p, 'target');
    addParameter(p,'init',zeros(1, numMasses*2));
    addParameter(p, 'time', 15);
    addParameter(p, 'damp', 0);
    addParameter(p, 'natFreq', 1.4); %measured natural frequency   
    parse(p,K, target, varargin{:});
    
    time = p.Results.time;
    init = p.Results.init;
    damp = p.Results.damp;
    n = p.Results.natFreq;
    
    M = makeM(numMasses, n);
    
    tRange = linspace(0,time,500);
    driving = makeDriving(K);
    [T, X] = ode45(@odeFunc, tRange, init);
    function B = odeFunc(t,X)
        B = M*X + driving(t);
    end

    if exist('target') == 1
        Error = sum((X-target).^2,2) + 3*exp(-T);
        [cost,idx] = min(Error); 
    else; cost = 0;   
    end
    
    for t = 1:length(tRange)
        d = driving(tRange(t));
        drive(t) = d(end,1); 
    end
    
    function M = makeM(numMasses, naturalFrequency)
        M = zeros(numMasses*2);
        M(1:numMasses,numMasses+1:end) = eye(numMasses);
        M(numMasses+1:end,1:numMasses) = naturalFrequency*(diag(ones(numMasses-1,1),1) + diag(ones(numMasses-1,1),-1) + -2*diag(ones(numMasses,1)));
        M(numMasses+1:end,numMasses+1:end) = diag(ones(numMasses,1),0)*-damp;
    end
    
    function driving = makeDriving(K)
        A = K(1:length(K)/2);
        F = K(length(K)/2+1:end);

        driveMatrix = zeros(numMasses*2,1);
        driveMatrix(end,1) = 1;
        driving = @(t) dot(sin(t*F),A) * driveMatrix;
    end

end