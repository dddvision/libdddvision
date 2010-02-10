% Computes the gradients of an array
% Uses a 4-element finite difference approximation
% Removes one-pixel borders that do not make sense by convolution
%
%    y = array (m-by-n)
%   gi = row gradient (m-by-n)
%   gj = column gradient (m-by-n)
function [gi,gj,gt]=SpatialGradients(y)
if (size(y,3)~=1)
   error('input must be a 2-dimensional array');
end

%vertical convolution mask
imask=[
  0  0  0;
  0 -1 -1;
  0  1  1]/2;

%horizontal convolution mask
jmask=[
  0  0  0;
  0 -1  1;
  0 -1  1]/2;

%perform convolution
gi=filter2(imask,y);
gj=filter2(jmask,y);

%the gradient is not defined at the image border, so black it out
gi=AdjustBorders(gi,1,1);
gj=AdjustBorders(gj,1,1);
end
