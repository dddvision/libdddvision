% Non-maxima suppression.
%
% @param[in]  gm     gradient magnitude
% @param[in]  theta  gradient direction counter clockwise from down direction in range [-pi, pi]
% @param[in]  thresh lower gradient magnitude threshold in the range [0, inf)
% @param[out] ridge  binary image indicating maxima along the gradient direction
function ridge = maxima(gm, theta, thresh)
[M, N] = size(gm);
ridge = false(M, N);

% exclude border and pixels with gradient magnitude less than thresh
gmTemp = gm;
gmTemp(1, :) = -1.0;
gmTemp(:, 1) = -1.0;
gmTemp(M, :) = -1.0;
gmTemp(:, N) = -1.0;
index = find(gmTemp>=thresh);
theta = theta(index);

% shift theta and reduce to four directional tests
lowTheta = theta<0.0;
theta(lowTheta) = theta(lowTheta)+pi;
lowTheta = theta<(1.0/8.0*pi);
theta(lowTheta) = theta(lowTheta)+pi;
theta = theta+(1.0/8.0*pi);
direction = floor(theta*(4.0/pi-eps));

% prepare variables for one line execution
offset = [M+1; M; M-1; 1];
od = offset(direction);
gmi = gm(index);

% do the test
ridge(index) = (gmi>gm(index-od))&(gmi>gm(index+od));
end
