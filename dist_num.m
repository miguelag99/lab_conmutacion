## Author: miguel <miguel@miguel-TM1613>
## Created: 2021-10-18

pkg load statistics

function inv = inv_func(x)
  inv = -log(x)/2;
endfunction


M = rand(1,1000);
result = inv_func(M);
M_exp = exprnd(1/2,1,1000);

figure
axis square
plot(sort(result),sort(M_exp))
hold on
plot([0:0.1:5],[0:0.1:5])


M = rand(1,10000);
result = inv_func(M);
M_exp = exprnd(1/2,1,10000);

figure
axis square
plot(sort(result),sort(M_exp))
hold on
plot([0:0.1:5],[0:0.1:5])


