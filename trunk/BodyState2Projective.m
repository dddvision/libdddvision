function M=BodyState2Projective(x,n,rho)
%INPUT:
%   x = body state, [quaternion;position]
%   n = image width in pixels
% rho = camera parameter
%
%OUTPUT:
%   M = projective transformation matrix
%








%calculate scaling
k=n/2*rho;

xT=x(5:7);
R=Quat2Matrix(x(1:4));

Minv=[[k*R(1,3),k*R(2,3),-k*R(:,3)'*xT]
      [k*R(1,2),k*R(2,2),-k*R(:,2)'*xT]
      [  R(1,1),  R(2,1),  -R(:,1)'*xT]];
    
M=inv(Minv);
M=M/M(9);

return
