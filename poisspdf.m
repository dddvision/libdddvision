% Calculates the probability density of the Poisson distribution
%      
% INPUT
% x = number in domain of Poisson distribution
% lambda = Poisson parameter (mean)
%
% OUTPUT
% y = value of Poisson distribution
% 








function y=poisspdf(x,lambda)
y=exp(-lambda+x.*log(lambda)-gammaln(x+1));
return;
