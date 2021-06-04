function I=TemporalSmooth(I0,I1,I2,I3,I4)
% TemporalSmooth() performs gaussian smooth over 2, 3, or 5 images
% The number of images determines the sigma of the gaussian
% Copyright 2002 David D. Diel, MIT License

switch nargin
    
case 2
I=0.5*I0+0.5*I12;

case 3
I=0.25*I0+0.5*I1+0.25*I2;

case 5
I=0.05*I0+0.25*I1+0.5*I2+0.25*I3+0.05*I4;

otherwise
fprintf('Error: TemporalSmooth() needs 2, 3, or 5 arguments');

end
return