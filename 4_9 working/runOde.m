function [T,X,drive,cost,idx] = runOde(K,target,init)
    if (exist('init') ~= 1); init = [0,0,0,0,0,0]; end
    n = 3.95; %measured natural frequency
    M = [0 0 0 1 0 0;
         0 0 0 0 1 0;
         0 0 0 0 0 1;
         -2*n n 0 0 0 0;
         n -2*n n 0 0 0;
         0 n -2*n 0 0 0];
     
    tRange = linspace(0,15,500);
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
    
    function driving = makeDriving(K)
        A = K(1:length(K)/2);
        F = K(length(K)/2+1:end);
        driveMatrix = zeros(6,1);
        driveMatrix(end,1) = 1;
        driving = @(t) dot(sin(t*F),A) * driveMatrix;
    end
end