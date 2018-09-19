function moveServos(Ks, Servos, Times, scaling, dispOnly)
   
   maxT = max(Times);
   for j = 1:length(Times)
        startTimes(j) = maxT-Times(j);
   end
    
   for i =  1:length(Servos)
       K = Ks(i,:);
       As(i, :) = K(1:length(K)/2);
       Fs(i, :) = K(length(Ks)/2+1:end);
       driving{i} = @(t, startTime, i) ...
           ifelse( t<startTime, .5, ...
           dot(sin((t-startTime) * Fs(i, :)),As(i, :))/scaling +.5);
%             ifelse(t<maxT,dot(sin((t-startTime)*Fs(i, :)),As(i, :))/scaling +.5, .5));
           
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
   clf(figure(2))
   while t < maxT
      t = etime(clock , t0);
      for i = 1:length(Servos)

          if Servos(i) == i-1
              subplot(5,1,i)
               hold on
               plot(t,driving{i}(t,startTimes(i),i),'.')
          else
               writePosition(Servos(i), driving{i}(t, startTimes(i), i));
          end
          
           
      end
      
   end
   if ~dispOnly
       pause(3)

       for i =  1:length(Servos)
           writePosition(Servos(i),.5)
       end
   end

end