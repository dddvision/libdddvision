function [minVal, maxVal, theta] = Eig2(xx, yy, xy)
% Public Domain
if(nargin==1)
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
