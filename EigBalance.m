% Finds corners with balanced eigenvalues of the symmetric 2x2 matrix
% [xx xy]
% [xy yy]
%
% If xx,yy,xy are sums of local image gradients.
% Copyright 2006 David D. Diel, MIT License

function val=EigBalance(xx,yy,xy)
  pow=1.5;
  val=(xx.*yy-xy.*xy)./((xx+yy+eps).^pow);
end

