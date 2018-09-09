function moveOneServo(K, States)
<<<<<<< Updated upstream

=======
    numMasses = 5;
    for targetNum = 0:1:(2^(numMasses-1)-1)     
        biV = de2bi(targetNum, numMasses);
        biV(biV==0)=-1;
        statesM(targetNum+1, :) = cat(2, zeros(1, numMasses), biV);
    end
    statesM(4,:)
    
>>>>>>> Stashed changes
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
    [T,X,drive,~,idx] = runOde(K,statesM(4,:));
    tRange = linspace(0,10,500);
    driving = @(t) dot(sin(t*F),A)/10 +.5;

    clf(figure(1))
    hold on

    pause(1)
    t0 = clock;
    t = 0;

    while t < 15
       t = etime(clock , t0);
       writePosition(s,driving(t))
       if t > T(idx)
           poop
       end
    end

    pause(3)
    writePosition(s,.5)

end