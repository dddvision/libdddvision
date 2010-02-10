% Performs general projective warping
% The warping matrix can be a subset of projective,
%   such as affine, Euclidean, pure translation, or pure rotation
% Assumes a row-column coordinate system with its origin in the image center
% Matlab iterates through the destination image coordinates
%   and draws values from the source image via bilinear interpolation 
%
%   y = image to be warped
% pad = (optional) pixel values beyond the borders of the input image
%  sz = (optional) size of output image, if different from input image
%
% Warping Parameters:
% P = [[a1 a2 b1]
%      [a3 a4 b2]
%      [c1 c2 1 ]];
%
% Homogenous Coordinates:
% H = [ic;jc;1]
%
% Post-Warp Coordinates
% Hwarp = P*H
function y=Warp(y,P,pad,sz)

%size of input images
[m,n]=size(y);

%size of output image
if nargin>3
  mout=sz(1);
  nout=sz(2);
else
  mout=m;
  nout=n;
end

if nargin<3
  pad=0.5;
end

%rearrange the parameters into the form required by Matlab
tform=maketform('projective',[
  [P(5) P(4) P(6)]    
  [P(2) P(1) P(3)]
  [P(8) P(7) P(9)]]);

%call the transformation function from the image processing toolbox
y=imtransform(y,tform,'VData',[(1-m)/2 (m-1)/2],'UData',[(1-n)/2 (n-1)/2],'YData',[(1-mout)/2 (mout-1)/2],'XData',[(1-nout)/2 (nout-1)/2],'FillValues',pad);
end
