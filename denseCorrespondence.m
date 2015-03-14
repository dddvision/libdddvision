% Compute dense correspondence field given two images and constraints.
%
% @param[in] a     first image
% @param[in] b     second image
% @param[in] diMax maximum absolute value of displacement in step direction
% @param[in] djMax maximum absolute value of displacement in stride direction
% @param[in] dtMax maximum absolute value of displacement in angle
% @param[in] dsMax maximum absolute value of displacement in scale
% TODO: consider providing minimum and maximum in each transformation dimension
%
%IDEAS:
% use tiny 3x3 or 2x2 support
% allow small rotation and scale
function [di, dj] = denseCorrespondence(a, b, diMax, djMax, dtMax, dsMax)
if(nargin==0)
  close('all');
  a = imread('data/RubberWhaleA.png');
  b = imread('data/RubberWhaleB.png');
  [di, dj] = denseCorrespondence(a, b, diMax, djMax, dtMax, dsMax);
  rgb = colorize(di, dj, 5);
  figure;
  imshow([a, b, 255*rgb]);
  di = [];
  dj = [];
  return;
end
load('data/RubberWhaleFlow.mat');
di = diTruth;
dj = djTruth;
end

function d = matchMetric(a, b, pi, pj)

end

function rgb = colorize(di, dj, rMax)
r = sqrt(di.*di+dj.*dj);
r(r>1e9) = nan;
theta = atan2(di, -dj);
rgb = hsv2rgb(0.5+theta./(2.0*pi), r./rMax, ones(size(r)));
end
