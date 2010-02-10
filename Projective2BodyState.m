function x=Projective2BodyState(M,n,rho)
%INPUT:
%   M = projective transformation matrix
%   n = image width in pixels
% rho = camera parameter
%
%OUTPUT:
%   x = body state, [quaternion;position]
%








%calculate scaling
k=n/2*rho;

%invert the projection matrix
Minv=inv(M);
Minv=Minv/Minv(9);

%solve for both answers, and keep the one that is above ground
x=zeros(7,1);
for sn=[-1,1]
  
  %body orientation
  R1=-[Minv(3);Minv(2)/k;Minv(1)/k];
  q1=sn/norm(R1); %choose positive denominator
  R1=R1*q1; %enforce unit magnitude
  
  R2=-[Minv(6);Minv(5)/k;Minv(4)/k];
  R2=(eye(3)-R1*R1')*R2; %enforce perpendicularity to R1
  R2=sn*R2/norm(R2); %enforce unit magnitude, positive denominator
  
  R3=cross(R1,R2); %enforce right-hand-rule
  
  R=[R1,R2,R3]';

  %body orientation in quaternion form
  x(1:4)=Matrix2Quat(R);
  
  %body position
  x(5:7)=R*[q1;q1/k*Minv(8);q1/k*Minv(7)];

  %translation "Down" must be negative
  if x(7)<0
    break
  end
end
