clc
clear('a')
clear('s')
a = arduino;
s = servo(a,'D4');

[T,X,drive] = runOde([1,6],[0,0,0,0,0,0],[0,0,0,0,0,0]);

t0 = now+3000;
clf(figure(1))
hold on

for i=1:length(T)
    t = T(i);
    while t < (now-t0); end
    writePosition(s,drive(i)/10+.5)
    plot(t,readPosition(s),'k.')
    drawnow
    
    if T(i) > 7
        writePosition(s,driving(0))
        break
    end
end


 


