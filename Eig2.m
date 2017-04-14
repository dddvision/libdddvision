function [minVal, maxVal, theta] = Eig2(xx, yy, xy)
if(nargin==1)
%   [fi, fj] = fineEdge(imresize(xx, 0.5));
%   fii = fineEdge(imresize(fi, 0.5));
%   [fji, fjj] = fineEdge(imresize(fj, 0.5));
%   [fi, fj] = ComputeDerivatives2(xx);
%   fii = ComputeDerivatives2(fi);
%   [fji, fjj] = ComputeDerivatives2(fj);
  [fi, fj] = gradient(xx);
  fii = gradient(fi);
  [fji, fjj] = gradient(fj);
  [minVal, maxVal, theta] = Eig2(fii, fjj, fji);
  return;
end
a = (xx+yy)/2;
b = xx-yy;
s = sqrt(b.*b+4*xy.*xy)/2;
minVal = a-s;
if(nargout>=2)
  maxVal = a+s;
end
if(nargout>=3)
  theta = atan2(xy, maxVal-yy);
end
end
