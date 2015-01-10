% Compute dense correspondence field given two images and constraints.
%
% @param[in]  a          first image
% @param[in]  b          second image
% @param[in]  dStrideMax maximum absolute value of displacement in stride direction (pixels)
% @param[in]  dStepMax   maximum absolute value of displacement in step direction (pixels)
% @param[in]  dAngleMax  maximum absolute value of displacement in angle CCW from right (radians)
% @param[out] dStride    displacement in stride direction (pixels)
% @param[out] dStep      displacement in step direction (pixels)
%
%IDEAS:
% use tiny 3x3 support
% allow small rotation and scale
% solve precisely over +/-0.5 pixel translation and small rotation
% use concept of partial support
% if current state is equally good as perturbed state, then choose current
% use concept of propigation
% pre-compute (cubic?) interpolation factors over image b so it can be queried quickly
% invent descriptor that finds the "corner postion and orientation" given a 3x3
% derive di, dj, dt from variational theory
function [dStride, dStep] = denseCorrespondence(a, b, dStrideMax, dStepMax, dAngleMax)
if(nargin==0)
  close('all');
  a = imread('data/RubberWhaleA.png');
  b = imread('data/RubberWhaleB.png');
  dStrideMax = 0.5;
  dStepMax = 0.5;
  dAngleMax = atan(0.5);
  [dStride, dStep] = denseCorrespondence(a, b, dStrideMax, dStepMax, dAngleMax);
  rgb = colorize(dStride, dStep, 5.0);
  figure;
  imshow([a, b, 255*rgb]);
  dStride = [];
  dStep = [];
  return;
end
step = 5;
stride = 5;
dStep = 0.25;
dStride = 0.25;
dAngle = 0.01;
d = matchMetric(a, b, step, stride, dStep, dStride, dAngle);
load('data/RubberWhaleFlow.mat');
dStride = dStrideTruth;
dStep = dStepTruth;
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
