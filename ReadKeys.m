function [T,X,Q,Qd,n] = ReadKeys(filename)
% Loads animation keyframe motion data.
% The input system of units is seconds, meters, and degrees.
%
% COORDINATE SYSTEM:
% Translation, relative to earth fixed frame
%   X = North 
%   Y = East
%   Z = Geodetic Down
%
% Euler orientation
%   A = pan right
%   B = tilt up
%   C = spin clockwise
%
% Euler rates, expressed in body axes
%   D = pan right about rotated A axis
%   E = tilt up about rotated B axis
%   F = spin clockwise about rotated C axis
%
% FILE FORMAT:
% [time stamp] [X] [Y] [Z] [A] [B] [C] [D] [E] [F]
%    . . .
%    . . .
%
% RETURN VALUES:
% Aerospace style (right-hand, X-forward, Z-down, radians)
%  T = time stamp vector (1-by-n)
%  X = camera positions in world frame (3-by-n)
%  Q = quaternions in unrotated frame (scalar-vector) (4-by-n)
% Qd = quaternion rates in unrotated frame (4-by-n)
%  n = number of keys read

%read keyframe data
K=dlmread(filename,'\t');

K=K'; %change formats
[m,n]=size(K);

if m~=10
    error([filename,' must contain m-by-10 tab delimited matrix']);
end
if sum(K(:,end)==0)==10
	warning('last line of keyframe file contains zeros or whitespace'); 
end

%extract time stamp
T=K(1,:);
if sum(double(diff(T)<0.000001))>0
	error('keyframe times must increase monotonically and significantly');
end

%extract position
X=K(2:4,:);

%convert to radians
K(5:10,:)=K(5:10,:)*(pi/180);

%extract Euler angles
pan=K(5,:);
tilt=K(6,:);
spin=K(7,:);

%extract Euler rates (reverse order)
er(3,:)=K(8,:);
er(2,:)=K(9,:);
er(1,:)=K(10,:);

%convert from pan-tilt-spin (reverse order) to scalar-vector quaternions
Q=Euler2Quat([spin;tilt;pan]);

Qd=zeros(4,n);
for i=1:n
  Qd(:,i)=0.5*Quat2Homo(Q(:,i))*[0;er(:,1)]; %qd=1/2*q*omega
end

return