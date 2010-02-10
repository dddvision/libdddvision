% Fisheye camera rays
% original algorithm from POV-Ray source code
% modified to right-handed coordinate system
% c1=forward
% c2=right from center
% c3=down from center
% FOV = currently is a hack to create a mask that limits the field-of-view
%









function [c1,c2,c3]=Fisheye_c(m,n,FOV)

phi=zeros(m,n);
theta=zeros(m,n);

[right,down]=meshgrid((1:n)*(2/(n-1))+(1+n)/(1-n),(1:m)*2/(n-1)+(m+1)/(1-n)); %verified

r=sqrt(down.*down+right.*right);

a=(r>1);
b=(r==0);
ca=((r~=0)&(right<0));
cb=((r~=0)&(right>=0));

phi(b)=0;
phi(ca)=pi-asin(down(ca)./r(ca));
phi(cb)=asin(down(cb)./r(cb));

theta=r*(pi/2);

cp=cos(phi);
ct=cos(theta);
sp=sin(phi);
st=sin(theta);

c1=ct;
c2=cp.*st;
c3=sp.*st;

c1(a)=NaN;
c2(a)=NaN;
c3(a)=NaN;

if (FOV~=pi)
  warning('Field-Of-View is not hemispherical');
  outside=find(c1(:)<cos(FOV/2));
  c1(outside)=NaN;
  c2(outside)=NaN;
  c3(outside)=NaN;
end  

return
