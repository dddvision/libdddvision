function [di, dj] = denseCorrespondence(a, b)
if(nargin==0)
  close('all');
  a = imread('data/RubberWhaleA.png');
  b = imread('data/RubberWhaleB.png');
  [di, dj] = denseCorrespondence(a, b);
  rgb = colorize(di, dj, 5);
  figure;
  imshow([a, b, 255*rgb]);
  di = [];
  dj = [];
  return;
end
%load('data/RubberWhaleFlow.mat');
%di = diTruth;
%dj = djTruth;
end

function rgb = colorize(di, dj, rMax)
r = sqrt(di.*di+dj.*dj);
r(r>1e9) = nan;
theta = atan2(di, -dj);
rgb = hsv2rgb(0.5+theta./(2.0*pi), r./rMax, ones(size(r)));
end
