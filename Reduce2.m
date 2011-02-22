% Computes smaller layer of a conservative pyramid
function y = Reduce2(x)
  [M, N] = size(x);
  if(mod(M, 2))
    x(M+1, :) = x(M, :);
    M = M+1;
  end
  if(mod(N, 2))
    x(:, N+1) = x(:, N);
    N = N+1;
  end
  y = x(1:2:M, 1:2:N)+x(2:2:M, 1:2:N)+x(1:2:M, 2:2:N)+x(2:2:M, 2:2:N);
end
