% Numerical approximation of cosine integral function.
function y = cosintn(x)
gamma = 0.5772156649015328606;
f = @(t)((cos(t)-1.0)./max(t, eps));
y = zeros(size(x));
for k = 1:numel(x)
  y(k) = gamma+log(x(k))+quadgk(f, 0.0, x(k));
end
end
