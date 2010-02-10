function I=Warp3(I,M,pad,scale)
% Warp3() performs projective warping
%
% M=[[a1 a2 b1]
%    [a3 a4 b2]
%    [c1 c2 1 ]];
%
% scale=output scaling factor
% assumes default coordinate system (may be changed later)
%
%Copyright David D. Diel Dec. 3, 2001
%all rights reserved

[m,n]=size(I);

tform=maketform('projective',[
[M(5) M(4) M(6)]    
[M(2) M(1) M(3)]
[M(8) M(7) M(9)]]);

if nargin<3
    pad=0;
end

if nargin==4
    I=imtransform(I,tform,'VData',[(1-m)/2 (m-1)/2],'UData',[(1-n)/2 (n-1)/2],'YData',[(1-m)/2 (m-1)/2]*scale,'XData',[(1-n)/2 (n-1)/2]*scale,'FillValues',pad);
else
    I=imtransform(I,tform,'VData',[(1-m)/2 (m-1)/2],'UData',[(1-n)/2 (n-1)/2],'YData',[(1-m)/2 (m-1)/2],'XData',[(1-n)/2 (n-1)/2],'FillValues',pad);
end

return