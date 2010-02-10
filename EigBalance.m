function val=EigBalance(xx,yy,xy)
% Finds corners with balanced eigenvalues of the symmetric 2x2 matrix
% [xx xy]
% [xy yy]
%
% If xx,yy,xy are sums of local image gradients.
%









pow=1.5;

val=(xx.*yy-xy.*xy)./((xx+yy+eps).^pow);

return
