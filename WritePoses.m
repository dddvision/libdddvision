function []=WritePose(path,T,Q) 
% Writes camera positions and orientations in the POV-Ray coordinate system.
% Rotations are applied about the camera origin, in left-handed x-y-z order.
% Translation is relative to the unrotated world coordinate system.
% The input system of units is seconds, meters, and radians.
% The output angles are converted to degrees.
%
% ARGUMENTS:
% path = directory in which to deposit the pose######.dat files 
% T = time stamp vector
% Q = state vectors, quaternions and positions (7-by-n)
%
% FILE FORMAT:
% [time stamp], <[Tx], [Ty], [Tz]>, <[Rx], [Ry], [Rz]>
%
% this function has been tested within narrow range of rotations
% Copyright 2006 David D. Diel, MIT License

n=length(T);

[a,b]=size(Q);
if (a~=7)|(b~=n)
    error('state matrix must be 7-by-n');
end

%extract rotation and translation components
qR=Q(1:4,:);
qX=Q(5:7,:);

%transform to POV coordinates
POV=[[0,1, 0]
     [0,0,-1]
     [1,0, 0]];

Xpov=POV*qX;
Qpov=[qR(1,:);-POV*qR(2:4,:)];
Epov=tom.Rotation.quatToEuler(Qpov)*(180/pi);

%write the files
for k=1:n
   
   fn=fullfile(path,['pose',num2str(k,'%06d'),'.dat']);
   
	fid = fopen(fn, 'w');
   if fid<0
     	error(['unable to open ' fn]);
   end;
   fprintf(fid,'%0.6f,<%0.6f,%0.6f,%0.6f>,<%0.6f,%0.6f,%0.6f>\t',...
    	[T(k);Xpov(1,k);Xpov(2,k);Xpov(3,k);Epov(1,k);Epov(2,k);Epov(3,k)]);
   fclose(fid);
   
end

return