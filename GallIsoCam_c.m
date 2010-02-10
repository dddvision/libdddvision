function [c1,c2,c3,m]=GallIsoCam_c(m,n,FOV)
%FOV is the horizontal field of view in radians, typically 2*pi
%not verified

[right,down]=meshgrid((1:n)*(2/(n-1))+(1+n)/(1-n),(1:m)*2/(n-1)+(m+1)/(1-n)); %verified

a=(FOV/(2*sqrt(2)))*down;
b=(FOV/2)*right;

a(find(abs(a)>(pi/2)))=NaN;
b(find(abs(b)>pi))=NaN;
cosa=cos(a);

c1=cos(b).*cosa;
c2=sin(b).*cosa;
c3=sin(a);

end
