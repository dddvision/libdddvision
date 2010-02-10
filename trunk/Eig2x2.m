% Calculates the two eigenvalues of the symmetric 2x2 matrix
%
% [xx xy]
% [xy yy]
%
% RETURN ARGUMENTS
% lam1=smallest eigenvalue
% lam2=largest eigenvalue
function [lam1,lam2]=Eig2x2(xx,yy,xy)

dif=xx-yy;
a=(xx+yy)/2;
b=sqrt(dif.*dif+4*xy.*xy)/2;
lam1=a-b;
lam2=a+b;

end
