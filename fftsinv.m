% Shifted fourier transform inverse.
% Public Domain
function f = fftsinv(F, varargin)
Fs = ifftshift(F);
switch(sum(size(Fs)>1))
  case 1
    fc = ifft(Fs, varargin{:});
  case 2
    fc = ifft2(Fs, varargin{:});
  otherwise
    error('unhandled dimensions');
end
f = abs(fc);
end