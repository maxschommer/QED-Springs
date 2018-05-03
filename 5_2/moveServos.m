function moveServos(Ks, Servos, Times)
    maxT = max(Times)
    for j = 1:length(Times)
        startTimes(j) = maxT-Times(j);
    end
    
    for i =  1:length(Servos)
        K = Ks(1,:);
        As(i, :) = K(1:length(K)/2);
        Fs(i, :) = K(length(Ks)/2+1:end);
        driving{i} = @(t, startTime, i) ifelse( t<startTime, .5, ifelse(t<maxT, dot(sin((t-startTime)*Fs(i, :)),As(i, :))/10 +.5, .5));
    end
    
    function out=ifelse(condition,answer1,answer2)
         if condition
           out=answer1;
         else
           out=answer2;
         end
         
     end
    
    
    pause(1)
    t0 = clock;
    t = 0;

    while t < 25
       t = etime(clock , t0);
       for i = 1:length(Servos)
           i
           startTimes(i)
           driving{i}(t, startTimes(i), i)
           writePosition(Servos(i), driving{i}(t, startTimes(i), i))
       end
       
%        writePosition(s1,driving(t))
%        writePosition(s2,driving(t))
%        writePosition(s3,driving(t))
%        writePosition(s4,driving(t))
%        writePosition(s5,driving(t))
    end

    pause(3)
    
    for i =  1:length(Servos)
        writePosition(Servos(i),.5)
    end

end