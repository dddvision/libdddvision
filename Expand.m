% Computes large layer of Gaussian pyramid
function large = Expand(small)

% prepare convolution mask
mask = [0.0217, 0.2283, 0.5000, 0.2283, 0.0217];

% get small image size
[M, N] = size(small);

% duplicate rows and convolve with horizontal mask
small = repmat(small, [2, 1]);
medium = reshape(small(:), M, 2*N);
medium = conv2(medium, mask, 'same');
medium = medium';

% duplicate columns and convolve with vertical mask
medium = repmat(medium, [2, 1]);
large = reshape(medium(:), 2*N, 2*M);
large = conv2(large, mask,'same');
large = large';

end

