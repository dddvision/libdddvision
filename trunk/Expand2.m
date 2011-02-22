% Computes smaller layer of a conservative pyramid
function y = Expand2(x)
  [M, N] = size(x);
  y = zeros(2*M, 2*N);
  x = x/4;
  y(1:2:end, 1:2:end) = x;
  y(2:2:end, 1:2:end) = x;
  y(1:2:end, 2:2:end) = x;
  y(2:2:end, 2:2:end) = x;
end
