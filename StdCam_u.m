function [u1,u2]=StdCam_u(c1,c2,c3,FOV)
% Copyright 2006 David D. Diel, MIT License

rho=cot(FOV/2);

behind=find(c1(:)<=0);

u1=rho*c3./c1;
u2=rho*c2./c1;

u1(behind)=NaN;
u2(behind)=NaN;

end
