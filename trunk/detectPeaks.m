function k = detectPeaks(x, dt)
  a = exp(-dt/2);
  y = bienvelope(x, a);
  [junk, k] = findpeaks(y); % find(x==y);
end

function y = bienvelope(x, a)
  [M, N] = size(x);
  yF = envelope(x, a);
  if(M>N)
    yB = flipud(envelope(flipud(x), a));
  else
    yB = fliplr(envelope(fliplr(x), a));
  end
  y = max(yF, yB);
end

function y = envelope(x, a)
  y = zeros(size(x));
  y(1) = x(1);
  for k = 2:numel(x)
    if(x(k)>=y(k-1))
      y(k) = x(k);
    else
      y(k) = a*y(k-1);
    end
  end
end
