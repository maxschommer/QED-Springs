stateInfo = load('StateInfo5MScaled');
Ks = stateInfo.Ks;
States = stateInfo.States;
Ks(:, length(Ks(1, :))/2+1:end) = Ks(:, length(Ks(1, :))/2+1:end)*2.82142857143;
save('StateInfo5MScaled','Ks', 'States')


clear all
load('StateInfo5MSing.mat')
terms = 10;
K = Ks(5,:);

a = arduino;
s1 = servo(a,'D2');
s2 = servo(a,'D3');
s3 = servo(a,'D4');
s4 = servo(a,'D5');
s5 = servo(a,'D6');

moveFiveServos(K,s1,s2,s3,s4,s5)