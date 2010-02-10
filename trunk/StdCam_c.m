function [c1,c2,c3]=StdCam_c(m,n,FOV)
%FOV is field-of-view in width, not height
%








rho=cot(FOV/2);

[right,down]=meshgrid((1:n)*(2/(n-1))+(1+n)/(1-n),(1:m)*2/(n-1)+(m+1)/(1-n)); %verified

mag=sqrt(right.*right+down.*down+rho^2);

c1=rho./mag;
c2=right./mag;
c3=down./mag;

return
