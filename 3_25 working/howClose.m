function [minError,t,X,F,idx] = howClose(A, F, target, wantPlot)
    % howClose([1,1,1],[.2,1,1.3],[-1,0,1,0,-2,-1],true)
    
    n = length(target)/2; % n masses
    init = zeros(1,n*2);
    tRange = linspace(0,10,500);
    M = makeM(n); %the spring relation matrix
    driving = makeDriving(n,A,F); %forcing function
    
    [t, X] = ode45(@odeFunc, tRange, init);
    function B = odeFunc(t,X)
        B = M*X + driving(t);
    end
    
    Error = sum((X-target).^2,2) + 3*exp(-t);
    [minError,idx] = min(Error);
    F = driving;
    if wantPlot; makeplot(); end
    
    function M = makeM(n)
        M = zeros(n*2);
        M(1:n,n+1:end) = eye(n);
        M(n+1:end,1:n) = diag(ones(n-1,1),1) + diag(ones(n-1,1),-1) + -2*diag(ones(n,1));
    end

    function driving = makeDriving(n,A,F)
        driveMatrix = zeros(n*2,1);
        driveMatrix(n+1,1) = 1;
        driving = @(t) dot(sin(t*F),A) * driveMatrix;
    end

    function makeplot()
        
        
        time = t(idx);
        exes = ['kx';'bx';'rx';'gx';'cx';'mx'];
        clf(figure(1))
        hold on
        for i = 1:6
            plot(t,X(:,i),exes(i))
            plot(time, target(i),exes(i,:))
        end

        plot(t,Error./max(Error),'k:','linewidth',3)
        title(['Error: ' num2str(minError)])
        figure


        
        
        plot(tRange, drivingPlt);
    end
end

