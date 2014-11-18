% Scales the input image dimensions by 2 and returns smoothed gradients.
%
% @param[in]  x  real valued image in the range [0, 1]
% @param[out] gi gradient in the down direction
% @param[out] gj gradient in the right direction
%
% @note
% Smoothing works in conjunction with a scaling kenel to estimate gradients at a finer scale.
% The image border is extended in order to pre-adjust for the loss of border in the gradient operation.
function [gi, gj] = fineEdge(x)
if(nargin==0)
  close('all');
  clear('classes');  
  x = imread('peppers.png');
  x = double(rgb2gray(x))/255.0;
  %x = [0, 0, 0; 0, 1, 0; 0, 0, 0];
  figure,imshow(x);
  [gi, gj] = fineEdge(x);
  gm = sqrt(gi.*gi+gj.*gj);
  rgb = hsv2rgb(0.5+atan2(gj, gi)/(2*pi), 0.5*ones(size(gj)), gm./max(gm(:)));
  figure,imshow(rgb);
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
%x = smoothWindow(x, [1, 3], 0.5);
%x = smoothWindow(x, [3, 1], 0.5);
[gd, gc] = robertsCross(x);
[r, t] = cartesianToPolar(gd, gc);
t = t+pi/4.0; % rotate angle
[gi, gj] = polarToCartesian(r, t);
end

function x = addBorder(x)
x = [x(1, 1), x(1, :), x(1, end); x(:, 1), x, x(:, end); x(end, 1), x(end, :), x(end, end)];
end

function x = removeBorder(x)
x = x(2:(end-1), 2:(end-1));
end

function x = shrinkByOne(x)
[M, N] = size(x);
ma = 1:(M-1);
mb = 2:M;
na = 1:(N-1);
nb = 2:N;
x = (x(ma, na)+x(ma, nb)+x(mb, na)+x(mb, nb))/4.0;
end

function x = smoothWindow(x, win, sig)
kernel = fspecial('gaussian', win, sig);
x = filter2(kernel, x);
end

function [gd, gc] = robertsCross(x)
[M, N] = size(x);
ma = 1:(M-1);
mb = 2:M;
na = 1:(N-1);
nb = 2:N;
gd = (x(mb, nb)-x(ma, na))/sqrt(2);
gc = (x(ma, nb)-x(mb, na))/sqrt(2);
end

function [r, t] = cartesianToPolar(x, y)
r = sqrt(x.*x+y.*y);
t = atan2(y, x);
end

function [x, y] = polarToCartesian(r, t)
x = r.*cos(t);
y = r.*sin(t);
end
