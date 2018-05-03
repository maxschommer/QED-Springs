function moveFiveServos(K,s1,s2,s3,s4,s5)

    A = K(1:length(K)/2);
    F = K(length(K)/2+1:end);
    driving = @(t) dot(sin(t*F),A)/10 +.5;

    pause(1)
    t0 = clock;
    t = 0;

    while t < 15
       t = etime(clock , t0);
       writePosition(s1,driving(t))
       writePosition(s2,driving(t))
       writePosition(s3,driving(t))
       writePosition(s4,driving(t))
       writePosition(s5,driving(t))
    end

    pause(3)
    
    writePosition(s1,.5)
    writePosition(s2,.5)
    writePosition(s3,.5)
    writePosition(s4,.5)
    writePosition(s5,.5)

end