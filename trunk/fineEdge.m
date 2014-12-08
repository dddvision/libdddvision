% Scales the input image dimensions by 2 and returns scaled smoothed gradients.
%
% @param[in]  x  real valued image in the range [0, 1]
% @param[out] gi gradient in the down direction
% @param[out] gj gradient in the right direction
%
% @note
% Smoothing works in conjunction with a scaling kenel to estimate gradients at a finer scale.
% The image border is extended in order to pre-adjust for the loss of border in the gradient operation.
function [gi, gj, gm, theta] = fineEdge(x)
if(nargin==0)
  close('all');
  clear('classes');
  x = imread('peppers.png');
  x = double(rgb2gray(x))/255.0;
  tic; [gi, gj, gm, theta] = fineEdge(x); toc; %#ok unused outputs
  %tic; [gj, gi] = gradient(x); gm = sqrt(gi.*gi+gj.*gj); theta = atan2(gj, gi); toc; % MATLAB gradient
  %tic; cEdge = edge(x, 'canny'); toc; % MATLAB edge
  tic; [ridge, sub] = maxima(gm, theta, 0.1); toc;
  mCrop = sum(gm, 2)>0.0;
  nCrop = sum(gm, 1)>0.0;
  %mCrop = 1:size(gm, 1);
  %nCrop = 1:size(gm, 2);
  rgb = colorize(gm(mCrop, nCrop), theta(mCrop, nCrop), ridge(mCrop, nCrop));
  %figure; imshow(cEdge);
  %figure; imshow(ridge(mCrop, nCrop));
  figure; imshow(rgb);
  figure; imshow(x);
  hold('on');
  [is, js] = getCoordinates(theta, ridge, sub);
  plot((js-0.5)/2.0+0.5, (is-0.5)/2.0+0.5, 'm.');
  gi = [];
  gj = [];
  return;
end
x = addBorder(x);
x = smoothWindow(x, [1, 3], 0.5);
x = smoothWindow(x, [3, 1], 0.5);
x = imresize(x, 2.0, 'lanczos3');
x = shrinkByOne(x);
x = removeBorder(x);
[gd, gc] = robertsCross(x);
clear('x');
[gm, theta] = cartesianToPolar(gd, gc);
clear('gd');
clear('gc');
theta = theta+pi/4.0; % rotate angle
if(nargout>3)
  % keep theta in the range [-pi, pi]
  big = theta>pi;
  theta(big) = theta(big)-2.0*pi;
end
[gi, gj] = polarToCartesian(gm, theta);
end

function x = addBorder(x)
x = [x(1, 1), x(1, :), x(1, end); x(:, 1), x, x(:, end); x(end, 1), x(end, :), x(end, end)];
end

function x = removeBorder(x)
x = x(2:(end-1), 2:(end-1));
end

% @note result is scaled by a factor of 4
function y = shrinkByOne(x)
[M, N] = size(x);
y = x(1:(M-1), 1:(N-1));
y = y+x(1:(M-1), 2:N);
y = y+x(2:M, 1:(N-1));
y = y+x(2:M, 2:N);
end

function x = smoothWindow(x, win, sig)
kernel = fspecial('gaussian', win, sig);
x = filter2(kernel, x);
end

% @note result is scaled by a factor of sqrt(2)
function [gd, gc] = robertsCross(x)
[M, N] = size(x);
gd = x(2:M, 2:N);
gd = gd-x(1:(M-1), 1:(N-1));
gc = x(1:(M-1), 2:N);
gc = gc-x(2:M, 1:(N-1));
end

function [r, t] = cartesianToPolar(x, y)
r = sqrt(x.*x+y.*y);
t = atan2(y, x);
end

function [x, y] = polarToCartesian(r, t)
x = r.*cos(t);
y = r.*sin(t);
end

function rgb = colorize(gm, theta, peak)
[M, N] = size(gm);
index = find(peak);
rgb = hsv2rgb(0.5+theta(index)/(2*pi), repmat(0.5, size(index)), gm(index)./max(gm(index)));
ri = rgb(:, 1, 1);
gi = rgb(:, 1, 2);
bi = rgb(:, 1, 3);
r = zeros(M, N);
g = zeros(M, N);
b = zeros(M, N);
r(index) = ri;
g(index) = gi;
b(index) = bi;
rgb = cat(3, r, g, b);
end

function [is, js] = getCoordinates(theta, ridge, sub)
index = find(ridge)';
[ii, ji] = ind2sub(size(ridge), index);
gi = cos(theta(index));
gj = sin(theta(index));
is  = ii+sub(index).*gi; 
js  = ji+sub(index).*gj;
end
