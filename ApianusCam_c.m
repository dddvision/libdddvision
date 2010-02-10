% INPUTS
% FOV = horizontal field of view in radians, typically 2*pi
%









function [c1,c2,c3,m]=ApianusCam_c(m,n,FOV)

[u2,u1]=meshgrid((1:n)*(2/(n-1))+(n+1)/(1-n),(1:m)*(2/(m-1))+(m+1)/(1-m)); %verified, different from others

scale=FOV/(2*pi);
ratio=n/(2*m);

u1=(scale*ratio)*u1;
u2=scale*u2;

bad=find((u1.*u1+u2.*u2)>=1);
u1(bad)=NaN;
u2(bad)=NaN;

a=(pi/2)*u1;
b=pi*u2./sqrt(1-u1.*u1);

cosa=cos(a);

c1=cos(b).*cosa;
c2=sin(b).*cosa;
c3=sin(a);

return
