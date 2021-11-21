% Returns the angular frequency in cycles per sample associated with each dimension of the shifted fourier transform.
% Public Domain
function [wm, wn] = fftsfreq(D)
wm = linspace(-0.5, 0.5-1.0/D(1), D(1));
switch(numel(D))
  case 1
    % do nothing
  case 2
    wn = linspace(-0.5, 0.5-1.0/D(2), D(2));
  otherwise
    error('unhandled dimensions');
end
end
