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
% solve precisely over +/-0.5 pixel translation and small rotation
% use concept of partial support
% if current state is equally good as perturbed state, then choose current
% use concept of propigation
% pre-compute (cubic?) interpolation factors over image b so it can be queried quickly
% invent descriptor that finds the "corner postion and orientation" given a 3x3
% derive di, dj, dt from variational theory
% Copyright 2006 David D. Diel, MIT License
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

% force image to have odd number of pixels in each dimension
% solve for motion of center pixel
% propagate outward and refine
% need a way to identify unique support
end

function d = matchMetric(a, b, stride, step, dStride, dStep, dAngle)
persistent M N sStride sStep
if(isempty(M))
  [M, N] = size(a);
  sStride = [-1, 0, 1; -1, 0, 1; -1, 0, 1];
  sStep = [-1, -1, -1; 0, 0, 0; 1, 1, 1];
end
a = double(a(:, :, 1)); % TODO: use all three colors
b = double(b(:, :, 1)); % TODO: use all three colors
ns = sStride;
ms = sStep;
as = a(sub2ind([M, N], step+ms(:), stride+ns(:)));
[ns, ms] = transform(sStride, sStep, dStride, dStep, dAngle);
bs = interpolate(b, step+ms(:), stride+ns(:));
d = 0.0;
end

function ys = interpolate(y, ms, ns)
ys = interp2(y, ns+1, ms+1);
end

function [xt, yt] = transform(x, y, dx, dy, da)
c = cos(da);
s = sin(da);
xt = x.*c-y.*s+dx;
yt = x.*s+y.*c+dy;
end

function rgb = colorize(dStride, dStep, rMax)
r = sqrt(dStep.*dStep+dStride.*dStride);
r(r>1e9) = nan;
theta = atan2(dStep, -dStride);
rgb = hsv2rgb(0.5+theta./(2.0*pi), r./rMax, ones(size(r)));
end

