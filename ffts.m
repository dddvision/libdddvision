% Shifted fourier transform.
% Public Domain
function F = ffts(f, varargin)
switch(sum(size(f)>1))
  case 1
    Fs = fft(f, varargin{:});
  case 2
    Fs = fft2(f, varargin{:});
  otherwise
    error('unhandled dimensions');
end
F = fftshift(Fs);
end