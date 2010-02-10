function [u1,u2]=Fisheye_u(c1,c2,c3,FOV)
%FOV currently unused

ep=1E-9;

center=find(abs(1-c1)<ep);
c1(center)=ep;
scale=(2/pi)*acos(c1)./sqrt(1-c1.*c1);
scale(center)=0;

behind=find(c1(:)<=0);

u1=scale.*c3;
u2=scale.*c2;

u1(behind)=NaN;
u2(behind)=NaN;  

end
