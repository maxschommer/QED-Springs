function moveOneServo(K, States)

    
    if exist('a') ~= 1
        a = arduino;
        s = servo(a,'D4');
        writePosition(s,.5)
    end

    if exist('K') ~= 1 
        K = gradDescent([0,0,0,1,0,0],'tolerance', .005);

    end
    A = K(1:length(K)/2);
    F = K(length(K)/2+1:end);
    
    tRange = linspace(0,10,500);
    driving = @(t) dot(sin(t*F),A)/10 +.5;

    clf(figure(1))
    hold on

    pause(1)
    t0 = clock;
    t = 0;

    while t < 2*pi
       t = etime(clock , t0);
       writePosition(s,driving(t))
    end

    pause(3)
    writePosition(s,.5)

end