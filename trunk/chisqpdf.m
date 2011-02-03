% Calculates the probability density of the chi-squared distribution
%      
% INPUT
% x = number in domain of chi-squared distribution
% nu = degrees of freedom parameter
%
% OUTPUT
% y = value of the chi-squared distribution
function y = chisqpdf(x, nu)
  a = nu/2;
  b = 2^a;
  c = b*gamma(a);
  y = ((x.^(a-1))./exp(x/2))./c;
end
