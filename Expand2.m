% Computes smaller layer of a conservative pyramid.
% Copyright 2006 David D. Diel, MIT License
function y = Expand2(x)
[M, N, P] = size(x);
if(P==1)
  y = zeros(2*M, 2*N);
  x = x/4;
  y(1:2:end, 1:2:end) = x;
  y(2:2:end, 1:2:end) = x;
  y(1:2:end, 2:2:end) = x;
  y(2:2:end, 2:2:end) = x;
else
  y = zeros(2*M, 2*N, P);
  x = x/4;
  for p = 1:P
    y(1:2:end, 1:2:end, p) = x(:, :, p);
    y(2:2:end, 1:2:end, p) = x(:, :, p);
    y(1:2:end, 2:2:end, p) = x(:, :, p);
    y(2:2:end, 2:2:end, p) = x(:, :, p);
  end
end
end
