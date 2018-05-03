clear all
numMasses = 5;
terms = 10;
K = rand(1,terms/2);
F = (1:length(K))/(1.6);

clf(figure(1))
hold on

for t = linspace(0,15,500)
   plot(t,dot(sin(t*F),K),'.') 
   drawnow
end