% Computes affine parameters that transform a point in the old image to a point in the new image.
%
% @param[in]  imageA old image
% @param[in]  imageB new image
% @param[in]  level  specifies how many pyramid levels to use
% @param[in]  itr    number of iterations per level
% @param[in]  mask   logical array that selects regions in the image to process
% @param[out] P      affine alignment parameters
%
% NOTES
% The coordinate system origin is at the image center.
% The transformation is:
%   P = [[a1, a2, b1]
%        [a3, a4, b2]
%        [ 0,  0,  1]];
%   XB = P*XA;
function P = AffineAlignment(imageA, imageB, level, itr, P, mask)

  % debug parameter
  show = false;

  % initialization
  pyramidA = cell(level, 1);
  pyramidB = cell(level, 1);
  pyramidA{1} = imageA;
  pyramidB{1} = imageB;
  if(nargin==6)
    w = cell(level, 1);
    w{1} = double(mask);
  end

  %create pyramid
  for i = 2:level
    pyramidA{i} = Reduce(pyramidA{i-1});
    pyramidB{i} = Reduce(pyramidB{i-1});
    if(nargin==6)
      w{i} = Reduce(w{i-1});
    end
    P(1:2, 3) = P(1:2, 3)/2.0;
  end

  for i = level:-1:1
    [m, n] = size(pyramidB{i});
    [xg, yg] = ndgrid(((1-m)/2):((m-1)/2), ((1-n)/2):((n-1)/2));

    if(i~=level)
      P(1:2, 3) = P(1:2, 3)*2.0;
    end

    for j = 1:itr
      warped = Warp3(pyramidB{i}, P);  

      % remove saturated regions
      temp = (warped<0.05)|(warped>0.95);
      temp = imdilate(temp, ones(3));
      bad = find(temp);

      [fxp, fyp, ftp] = ComputeDerivatives2(pyramidA{i}, warped);    

      fxp(bad) = 0.0;
      fyp(bad) = 0.0;
      ftp(bad) = 0.0;

      % optionally show residuals
      if(show)
        figure(1000);
        imshow(abs(ftp)./sqrt(fxp.*fxp+fyp.*fyp)/10.0);
        colormap jet;
        drawnow;
      end

      if(nargin==6)
        wi = find(w{i}(:)>0.5);

        x = xg(wi);
        y = yg(wi);

        fx = fxp(wi);
        fy = fyp(wi);
        ft = ftp(wi);
      else
        x = xg(:);
        y = yg(:);

        fx = fxp(:);
        fy = fyp(:);
        ft = ftp(:);
      end

      a1 = x.*fx;
      a2 = y.*fx;
      a3 = fx;
      a4 = x.*fy;
      a5 = y.*fy;
      a6 = fy;

      A(1, 1) = sum(a1.*a1);
      A(1, 2) = sum(a1.*a2);
      A(1, 3) = sum(a1.*a3);
      A(1, 4) = sum(a1.*a4);
      A(1, 5) = sum(a1.*a5);
      A(1, 6) = sum(a1.*a6);

      A(2, 1) = A(1, 2);
      A(2, 2) = sum(a2.*a2);
      A(2, 3) = sum(a2.*a3);
      A(2, 4) = A(1, 5);
      A(2, 5) = sum(a2.*a5);
      A(2, 6) = sum(a2.*a6);

      A(3, 1) = A(1, 3);
      A(3, 2) = A(2, 3);
      A(3, 3) = sum(a3.*a3);
      A(3, 4) = A(1, 6);
      A(3, 5) = A(2, 6);
      A(3, 6) = sum(a3.*a6);

      A(4, 1) = A(1, 4);
      A(4, 2) = A(2, 4);
      A(4, 3) = A(3, 4);
      A(4, 4) = sum(a4.*a4);
      A(4, 5) = sum(a4.*a5);
      A(4, 6) = sum(a4.*a6);

      A(5, 1) = A(1, 5);
      A(5, 2) = A(2, 5);
      A(5, 3) = A(3, 5);
      A(5, 4) = A(4, 5);
      A(5, 5) = sum(a5.*a5);
      A(5, 6) = sum(a5.*a6);

      A(6, 1) = A(1, 6);
      A(6, 2) = A(2, 6);
      A(6, 3) = A(3, 6);
      A(6, 4) = A(4, 6);
      A(6, 5) = A(5, 6);
      A(6, 6) = sum(a6.*a6);

      E = a1+a5-ft;
      
      B(1, 1) = sum(E.*a1);
      B(2, 1) = sum(E.*a2);
      B(3, 1) = sum(E.*a3);
      B(4, 1) = sum(E.*a4);
      B(5, 1) = sum(E.*a5);
      B(6, 1) = sum(E.*a6);

      if(condest(A)>(10^16))
        fprintf('AffineAlignment: Matrix is poorly conditioned.');   
      else
        p = A\B;
        dP = [[p(1), p(2), p(3)]
              [p(4), p(5), p(6)]
              [ 0.0,  0.0,  1.0]];
        P = dP*P;
        P = P/P(9);
      end
    end
  end
end
