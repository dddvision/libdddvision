% Computes the difference between two arrays using 4-element approximation
% Removes one-pixel borders that do not make sense by convolution
%
%   y1 = array (m-by-n)
%   y2 = array (m-by-n_
%   gt = finite difference (m-by-n)
function gt=ImageDifference(y1,y2)

if (size(y1,3)~=1)|(size(y2,3)~=1)
   error('inputs must be 2-dimensional arrays');
end

%convolution mask
tmask=[0  0  0;
       0  1  1;
       0  1  1]/4;

%apply the mask to both images and subtract
gt=filter2(tmask,y2)-filter2(tmask,y1);

%the above calculation is not defined at the image border, so black it out
gt=AdjustBorders(gt,1,1);

end
