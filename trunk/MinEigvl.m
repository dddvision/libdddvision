% Finds minimum eigenvalue of the symmetric 2x2 matrix
% [xx xy]
% [xy yy]
%
% If xx,yy,xy are sums of local image gradients,
% then MinEigvl() detects corners.
function val=MinEigvl(xx,yy,xy)
dif=xx-yy;
val=(xx+yy-sqrt(dif.*dif+4*xy.*xy))/2;
end
