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