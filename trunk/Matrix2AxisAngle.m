% Convert rotation matrices to axis-angle form
%
% INPUT
% RR = rotation matrices in layers, 3-by-3-by-K
%
% OUTPUT
% V = rotation vectors in axis-angle form, 3-by-K
%
% NOTES
% The magnitude of the output vector is the rotation angle in radians
% By Tony Falcone and David Diel

function V=Matrix2AxisAngle(RR)
  K=size(RR,3);
  V=zeros(3,K);
  for k=1:K
    R=RR(:,:,k);
    if(R(1,1) < 1.0)
      r22 = R(2,2) - (R(2,1) / (R(1,1) - 1.0))*R(1,2);
      r23 = R(2,3) - (R(2,1) / (R(1,1) - 1.0))*R(1,3);
      r32 = R(3,2) - (R(3,1) / (R(1,1) - 1.0))*R(1,2);
      r33 = R(3,3) - (R(3,1) / (R(1,1) - 1.0))*R(1,3);
      if((abs(r22-1.0)+abs(r23)) > (abs(r32)+abs(r33-1.0)))
        v(3)=1.0;
        v(2)=-r23/(r22-1.0);
      else
        v(2)=1.0;
        v(3)=-r32/(r33-1.0);
      end
      v(1)=(-(R(1,2)*v(2)+R(1,3)*v(3))/(R(1,1)-1.0));
      v=v*(1.0/norm(v));
    else
      v=[1;0;0];
    end
    V(:,k)=v*acos((trace(R)-1.0)/2.0);
  end
end
