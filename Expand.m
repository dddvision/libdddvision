% Computes large layer of Gaussian pyramid
%
% The implied coordinate system originates at
%   the center of the image
% Special thanks to Sohaib Khan
%
% Insert zeros in every alternate row position and conv with mask
% insert zeros in every alternate clmn position in result and conv with mask'
%








function largeIm = Expand(im)

mask = 2*[0,fspecial('gaussian',[1,6],1)];

% insert zeros in every alternate position in each row
rowZeros = [im; zeros(size(im))];
rowZeros = reshape(rowZeros, size(im,1), 2*size(im,2));

%conv with horiz mask
newIm = conv2(rowZeros, mask,'same');

% insert zeros in every alternate position in each col
colZeros = newIm';
colZeros = [colZeros; zeros(size(colZeros))];
colZeros = reshape(colZeros, size(colZeros,1)/2, 2*size(colZeros,2));
colZeros = colZeros';

largeIm=conv2(colZeros, mask','same');

return;
