function moveOneServo(K,s)

%     a = arduino;
%     s = servo(a,'D4');
    writePosition(s,.5)
    
    A = K(1:length(K)/2);
    F = K(length(K)/2+1:end);
    driving = @(t) dot(sin(t*F),A)/10 +.5;
    
    pause(1)
    t0 = clock;
    t = 0;

    while t < 25
       t = etime(clock , t0);
       writePosition(s,driving(t))
    end

    pause(3)
    writePosition(s,.5)

end