function [qi,qidot]=QuatInterp(method,q,t,ti,vdot)
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
  dq(:,j)=Quat2Homo(QuatConj(q(:,j)))*q(:,j+1); %incremental rotations
  dq(:,j)=dq(:,j)*sign(dq(1,j)); %unwrap rotations (may not be necessary)
end
dv=Quat2AxisAngle(dq); %incremental rotations in axis-angle form

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
      qi(:,i)=Quat2Homo(qo)*AxisAngle2Quat(dt*dv(:,j));  %qi(:,i)=SLERP(q(:,j),q(:,j+1),dt);
      qidot(:,i)=Quat2Homo(qi(:,i))*[0;dv(:,j)]/Ts;
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
      w2=Quat2AxisAngle(Quat2Homo(QuatConj(AxisAngle2Quat(w1)))*Quat2Homo(dq(:,j))*QuatConj(AxisAngle2Quat(w3)));
      B=Bh(dt);
      Bd=Bhd(dt);
      qo=Quat2Homo(qa);
      exp1=Quat2Homo(AxisAngle2Quat(B(1)*w1));
      exp2=Quat2Homo(AxisAngle2Quat(B(2)*w2));
      exp3=Quat2Homo(AxisAngle2Quat(B(3)*w3));
      wbd1=Quat2Homo([0;Bd(1)*w1]);
      wbd2=Quat2Homo([0;Bd(2)*w2]);
      wbd3=Quat2Homo([0;Bd(3)*w3]);
      qi(:,i)=qo*exp1*exp2*Homo2Quat(exp3);
      qidot(:,i)=qo*exp1*wbd1*exp2*Homo2Quat(exp3) + qo*exp1*exp2*wbd2*Homo2Quat(exp3) + qo*exp1*exp2*exp3*Homo2Quat(wbd3);
    end
    
  otherwise
    error('invalid method');
end

return


function x=Bh(t)
  tc=t.^3;
  x(1,:)=1-(1-t).^3;
  x(2,:)=3*t.*t-2*tc;
  x(3,:)=tc;
return

function xd=Bhd(t)
  xd(1,:)=3*(1-t).^2;
  xd(2,:)=6*t.*(1-t);
  xd(3,:)=3*t.*t;
return
