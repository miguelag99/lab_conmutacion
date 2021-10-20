clc; clear;

n_sample = 10000;


M = rand(1,n_sample);
result = -log(M)/2;
M_exp = exprnd(1/2,1,n_sample);

figure
axis square
plot(sort(result),sort(M_exp))
hold on
plot([0:0.1:5],[0:0.1:5])


M = rand(1,n_sample);
result = -log(M)/2;;
M_exp = exprnd(1/2,1,n_sample);

figure
axis square
plot(sort(result),sort(M_exp))
hold on
plot([0:0.1:5],[0:0.1:5])


