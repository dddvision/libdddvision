% Non-maxima suppression.
%
% @param[in]  gm     gradient magnitude
% @param[in]  theta  gradient direction counter clockwise from down direction in range [-pi, pi]
% @param[in]  thresh lower gradient magnitude threshold in the range [0, inf)
% @param[out] ridge  binary image indicating maxima along the gradient direction
% @param[out] sub    subpixel adjustment to position of ridge
% Copyright 2006 David D. Diel, MIT License
function [ridge, sub] = maxima(gm, theta, thresh)
[M, N] = size(gm);
ridge = false(M, N);

% exclude border and pixels with gradient magnitude less than thresh
gmTemp = gm;
gmTemp(1, :) = -1.0;
gmTemp(:, 1) = -1.0;
gmTemp(M, :) = -1.0;
gmTemp(:, N) = -1.0;
index = find(gmTemp>=thresh);
thetai = theta(index);

% shift theta and reduce to nine directional tests
direction = floor(thetai*(4.0/pi)+5.5); % adjust range to [1.5 9.5] then floor
offset = [-1; -M-1; -M; -M+1; 1; M+1; M; M-1; -1];
od = offset(direction);
gmi = gm(index);

if(nargout<2)
  % do quick test
  ridge(index) = (gmi>=gm(index-od))&(gmi>gm(index+od));
else
  % optionally output subpixel refinement
  lower = gmi-gm(index-od);
  upper = gmi-gm(index+od);
  ridgei = (lower>=0.0)&(upper>0.0);
  ridge(index) = ridgei;
  sub = zeros(M, N);
  mag = 0.5*sqrt(2)-mod(direction(ridgei), 2)*(0.5*sqrt(2)-0.5);
  sub(index(ridgei)) = mag.*(lower(ridgei)-upper(ridgei))./(upper(ridgei)+lower(ridgei));
end
end
