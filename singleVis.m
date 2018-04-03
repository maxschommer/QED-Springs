function singleVis()

    time = 2.16; %measured natural frequency
    t = (2*pi/time)^2;
    init = [0,1];
    
         M = [0 1
          -t 0];
     
    [times, positions] = ode45(@thetaDot, linspace(0,4*pi,500), init);
    plot(times,positions(:,2))
    ylim([ -1 1])
    title('Single Mass Position over Time')
    xlabel('Time')
    ylabel('Angle')

    function B = thetaDot(t,X)
        B = M * X;
    end

end