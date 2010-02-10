% AffineVelocity() finds local velocities assuming affine global motion
%
% x is the x-coordinate grid
% y is the y-coordinate grid
% R is a 2x2 rotation matrix
% T is a 1x2 translation matrix
%









function [u,v]=AffineVelocity(x,y,R,T)

u=(R(1,1)-1)*x+R(1,2)*y+T(1);
v=R(2,1)*x+(R(2,2)-1)*y+T(2);
return
