function [q,t]=ReadPose(filename)
%reads pose in POV-Ray left-handed Euler-angle format
%transform to quaternions

[t,qT(2,1),qT(3,1),qT(1,1),LH(1),LH(2),LH(3)]=textread(filename,'%f,<%f,%f,%f>,<%f,%f,%f>');

qT(3,1)=-qT(3,1); %flip POV up-axis to world down-axis
LH=(pi/180)*LH; %convert to radians

%apply rotation about -j, then k, then -i 
LH=LH/2;
s1=sin(LH(1));
s2=sin(LH(2));
s3=sin(LH(3));

c1=cos(LH(1));
c2=cos(LH(2));
c3=cos(LH(3));

qR(1,1)=c3*c2*c1+s3*s2*s1;
qR(2,1)=c3*s2*s1-s3*c2*c1;
qR(3,1)=-c3*c2*s1+s3*s2*c1;
qR(4,1)=s3*c2*s1+c3*s2*c1;

q=[qR;qT];

return