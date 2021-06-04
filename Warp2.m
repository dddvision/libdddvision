function I=Warp2(I,R,T)
% Warp2() performs affine warping
%
% R is a 2x2 rotation matrix
% T is a 2x1 translation vector
% assumes default coordinate system (may be changed later)
% Copyright 2002 David D. Diel, MIT License

[m,n]=size(I);

tform=maketform('affine',[
    R(4) R(3) 0;
    R(2) R(1) 0;
    T(2) T(1) 1]);

I=imtransform(I,tform,'VData',[(1-m)/2 (m-1)/2],'UData',[(1-n)/2 (n-1)/2],'YData',[(1-m)/2 (m-1)/2],'XData',[(1-n)/2 (n-1)/2]);

return