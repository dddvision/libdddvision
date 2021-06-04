function [u, v] = LucasKanade(im1, im2, windowSize);
%LucasKanade  lucas kanade algorithm, without pyramids (only 1 level);
% Copyright 2002 University of Central Florida, MIT License

%REVISION: NaN vals are replaced by zeros

[fx, fy, ft] = ComputeDerivatives2(im1, im2);

u = zeros(size(fx));
v = zeros(size(fx));

g = computeGaussian(ceil(windowSize/2), ceil(windowSize), eye(windowSize), windowSize, windowSize);
G = diag(g(:));

halfWindow = floor(windowSize/2);
for i = halfWindow+1:size(fx,1)-halfWindow
   for j = halfWindow+1:size(fx,2)-halfWindow
      curFx = fx(i-halfWindow:i+halfWindow, j-halfWindow:j+halfWindow);
      curFy = fy(i-halfWindow:i+halfWindow, j-halfWindow:j+halfWindow);
      curFt = ft(i-halfWindow:i+halfWindow, j-halfWindow:j+halfWindow);
      
      curFx = curFx';
      curFy = curFy';
      curFt = curFt';

      curFx = curFx(:);
      curFy = curFy(:);
      curFt = -curFt(:);
      
      A = [curFx curFy];
      
      U = inv(A'*G*A)*A'*G*curFt;
      
      u(i,j)=U(1);
      v(i,j)=U(2);
   end;
end;

u(isnan(u))=0;
v(isnan(v))=0;
end
