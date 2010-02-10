% The corner detector of Harris and Stephens
% based on the symmetric 2x2 matrix
% [xx xy]
% [xy yy]
%
% Where xx,yy,xy are sums of local image gradients
function val=HarrisCorner(xx,yy,xy)

val=(xx.*yy-xy.*xy)./(xx+yy+eps);

end


