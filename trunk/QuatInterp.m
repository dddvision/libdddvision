% performs quaternion interpolation
%
% INPUT:
% method = interpolation method
% q = quaternion control points (4-by-n)
% t = control point time stamps (1-by-n)
% ti = desired interpolation times (1-by-ni)
% vdot = velocities in unrotated coordinates, Axis-Angle form, if required by method (1-by-n)
%
% OUTPUT:
% qi = quaternions at interpolation times (4-by-ni)
% qidot = quaternion temporal derivative
%
% AVAILABLE METHODS:
% 'linear'
% 'hermite'
%
% REFERENCE
% Myoung-Jun Kim, Myung-Soo Kim, and Sung Yong Shin. A General Construction Scheme for Unit Quaternion 
% Curves with Simple High Order Derivatives. In Proc. of SIGGRAPH, pp. 369-376, 1995.

function [qi,qidot]=QuatInterp(method,q,t,ti,vdot)

[m,n]=size(q);
if m~=4
  error('input argument q should be (4-by-n)');
end

[tm,tn]=size(t);
if (tm~=1)|(tn~=n)
  error('input argument t should be (1-by-n)');
end

[tim,ni]=size(ti);
if (tim~=1)
  error('input argument ti should be (4-by-i)');
end

if (t(1)>ti(1)) | (t(end)<ti(end))
  error('interpolation times must fall within given times');
end

if (nargin<4)
  error('too few input arguments');
end

if (nargin>4)&~strcmp(method,'hermite')
  warning('too many input arguments');
end
  
%calculations used by all algorithms
dq=zeros(4,n-1);
for j=1:(n-1)
  dq(:,j)=tom.Rotation.quatToHomo(tom.Rotation.quatInv(q(:,j)))*q(:,j+1); %incremental rotations
  dq(:,j)=dq(:,j)*sign(dq(1,j)); %unwrap rotations (may not be necessary)
end
dv=tom.Rotation.quatToAxis(dq); %incremental rotations in axis-angle form

%for now, assume ti is always increasing and within the bounds of t,
%else return NaN or possibly crash
qi=zeros(4,ni)*NaN; 
qidot=zeros(4,ni)*NaN; 

switch method
  case 'linear'
    disp('QuatInterp method: linear');
  
    j=1;
    qo=q(:,1);
    for i=1:ni %for each interpolation point
      while(t(j+1)<ti(i))
        j=j+1;
      end
      qo=q(:,j);
      Ts=t(j+1)-t(j);
      dt=(ti(i)-t(j))/Ts;
      qi(:,i)=tom.Rotation.quatToHomo(qo)*tom.Rotation.axisToQuat(dt*dv(:,j));  %qi(:,i)=SLERP(q(:,j),q(:,j+1),dt);
      qidot(:,i)=tom.Rotation.quatToHomo(qi(:,i))*[0;dv(:,j)]/Ts;
    end
    
  case 'hermite'
    disp('QuatInterp method: hermite');
    
    j=1;
    qa=q(:,1);
    qb=q(:,2);
    for i=1:ni %for each interpolation point
      while(t(j+1)<ti(i))
        j=j+1;
      end
      dt=(ti(i)-t(j))/(t(j+1)-t(j));
      qa=q(:,j);
      qb=q(:,j+1);
      w1=vdot(:,j)/3;
      w3=vdot(:,j+1)/3;
      w2=tom.Rotation.quatToAxis(tom.Rotation.quatToHomo(tom.Rotation.quatInv(tom.Rotation.axisToQuat(w1)))*...
        tom.Rotation.quatToHomo(dq(:,j))*tom.Rotation.quatInv(tom.Rotation.axisToQuat(w3)));
      B=Bh(dt);
      Bd=Bhd(dt);
      qo=tom.Rotation.quatToHomo(qa);
      exp1=tom.Rotation.quatToHomo(tom.Rotation.axisToQuat(B(1)*w1));
      exp2=tom.Rotation.quatToHomo(tom.Rotation.axisToQuat(B(2)*w2));
      exp3=tom.Rotation.quatToHomo(tom.Rotation.axisToQuat(B(3)*w3));
      wbd1=tom.Rotation.quatToHomo([0;Bd(1)*w1]);
      wbd2=tom.Rotation.quatToHomo([0;Bd(2)*w2]);
      wbd3=tom.Rotation.quatToHomo([0;Bd(3)*w3]);
      qi(:,i)=qo*exp1*exp2*tom.Rotation.homoToQuat(exp3);
      qidot(:,i)=qo*exp1*wbd1*exp2*tom.Rotation.homoToQuat(exp3) + qo*exp1*exp2*wbd2*tom.Rotation.homoToQuat(exp3) + qo*exp1*exp2*exp3*tom.Rotation.homoToQuat(wbd3);
    end
    
  otherwise
    error('invalid method');
end

end


function x=Bh(t)
  tc=t.^3;
  x(1,:)=1-(1-t).^3;
  x(2,:)=3*t.*t-2*tc;
  x(3,:)=tc;
end

function xd=Bhd(t)
  xd(1,:)=3*(1-t).^2;
  xd(2,:)=6*t.*(1-t);
  xd(3,:)=3*t.*t;
end
