% Central chi-square probability density function
function y = chisqpdf(x, k)
  a = k/2;
  b = 2^a;
  c = b*gamma(a);
  d = x.^(a-1);
  f = exp(x/2);
  g = f.*c;
  y = d./g;
  bad = (k>100)|(d>(1/eps))|(g<eps); % identify numerical instability
  z = x(bad)-k+2; % adjust for degrees of freedom
  s = 4*k;
  y(bad) = exp(-z.*z/s)/sqrt(pi*s);
end
