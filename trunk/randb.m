% Generates uniform random numbers between symmetric bounds
% 
% INPUT
% m = number of rows
% n = number of columns
% b = positive bound
% 
% OUTPUT
% r = matrix of random numbers
% 








function r=randb(m,n,b)

r=(2*b)*rand(m,n)-b;

return;
