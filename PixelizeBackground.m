function RGB = PixelizeBackground(rgb, mask)
% Copyright 2006 David D. Diel, MIT License

  numLevels = 4;

  r = PBPrepareImage(rgb(:, :, 1), numLevels);
  g = PBPrepareImage(rgb(:, :, 2), numLevels);
  b = PBPrepareImage(rgb(:, :, 3), numLevels);
  
  R = r;
  G = g;
  B = b;
  
  bg = PBPrepareImage(mask, numLevels);
  bg = double(bg>0.5);
  bg = Smooth2(bg, [3, 3], 1);
  fg = 1-bg;

  for level = 2:numLevels
    r = Reduce2(r);
    g = Reduce2(g);
    b = Reduce2(b);
  end

  for level = 2:numLevels
    r = Expand2(r);
    g = Expand2(g);
    b = Expand2(b);
  end
  
  R = bg.*r+fg.*R;
  G = bg.*g+fg.*G;
  B = bg.*b+fg.*B;
  
  RGB = cat(3, R, G, B);

end

function img = PBPrepareImage(img, numLevels)
  img = double(img)/255;
  multiple = 2^(numLevels-1);
  [M, N] = size(img);
  Mpad = multiple-mod(M, multiple);
  Npad = multiple-mod(N, multiple);
  if((Mpad>0)||(Npad>0))
    img(M+Mpad, N+Npad) = 0; % allocates memory for padded image
  end
  if(Mpad>0)
    img((M+1):(M+Mpad), :) = NaN;
  end  
  if(Npad>0)
    img(:, (N+1):(N+Npad)) = NaN;
  end
end
