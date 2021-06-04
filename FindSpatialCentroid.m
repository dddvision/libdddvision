% FindCentroid
%
% INPUT
% im = binary image containing a region
%
% OUTPUT
% x,y = pixel coordinates of the centroid
%
% NOTES
% Tricky method but it is much faster than 2 loops
% Copyright 2006 David D. Diel, MIT License
function [x,y] = FindSpatialCentroid(im)
[m,n]=size(im);
[yCor,xCor]=meshgrid([1:n],[1:m]);
N = sum(im(:));
xval = xCor.*im;
yval = yCor.*im;
x = sum(xval(:))/N;
y = sum(yval(:))/N;
end
