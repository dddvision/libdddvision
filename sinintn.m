% Numerical approximation of sine integral function.
function y = sinintn(x)
f = @(t)(sin(t)./max(t, eps));
y = zeros(size(x));
for k = 1:numel(x)
  y(k) = quadgk(f, 0.0, x(k));
end
end
