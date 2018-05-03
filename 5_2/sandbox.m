stateInfo = load('StateInfo5MScaled');
Ks = stateInfo.Ks;
States = stateInfo.States;
Ks(:, length(Ks(1, :))/2+1:end) = Ks(:, length(Ks(1, :))/2+1:end)*2.82142857143;
save('StateInfo5MScaled','Ks', 'States')


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