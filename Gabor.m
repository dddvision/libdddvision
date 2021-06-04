%Produces mask of a cosine modulated by a Gaussian Window
% Mask can be used to take the circular fourier transform around a point
%
%k=number of cycles in the mas
%phase=periodic phase relative to a cosine
%win=mask size in two dimensions, must be odd (1-by-2)
%sig=variance of Gaussian
% Copyright 2002 University of Central Florida, MIT License
function [CosMask]=Gabor(k,phase,win,sig)

if ~(mod(win(1),2)&(mod(win(2),2)))
  error('window width and height must be odd');
end

%polar coordinate system
w=(win-1)/2;
[y,x]=meshgrid(-w(2):w(2),-w(1):w(1));
th=atan2(y,x);

%normalized gaussian with zero in the center
g=fspecial('gaussian',win,sig);
g(w(1)+1,w(2)+1)=0;

%mask shape
h=g.*cos(k*th+phase);

%normalize mask
CosMask=h/sqrt(sum(h(:).*h(:)));

end
