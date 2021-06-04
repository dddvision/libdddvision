function C = ImageMerge(A, B)
% Copyright 2006 David D. Diel, MIT License
  [AL, AH] = IMdecomp(A);
  [BL, BH] = IMdecomp(B);
  C = (AL+BH)/2;
end

function [L, H] = IMdecomp(A)
  A1 = A;
  A2 = Reduce(A1);
  A3 = Reduce(A2);
  A4 = Reduce(A3);
  A5 = Reduce(A4);
  A4 = Expand(A5);
  A3 = Expand(A4);
  A2 = Expand(A3);
  A1 = Expand(A2);
  L = A1;
  H = A-L+mean(L(:));
end
