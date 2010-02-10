function [qi,qid,qidd]=TransInterp(method,q,t,ti,qd)
% option 'linear' does not output velocities or accelerations

% INPUT:
% method = interpolation method
% q = position control points (m-by-n)
% t = control point time stamps (1-by-n)
% ti = desired interpolation times (1-by-ni)
% qd = velocities at control points, if required by method (1-by-n)
%
% OUTPUT:
% qi = positions at interpolation times (m-by-ni)
%
% AVAILABLE METHODS:
% 'linear'
% 'cubic'
% 'controlled'

if (t(1)>ti(1))|(t(end)<ti(end))
    error('interpolated times must fall within keyframe times');
end

[m,n]=size(q);

[tm,tn]=size(t);
if (tm~=1)|(tn~=n)
  error('input argument t should be (1-by-n)');
end

[tim,ni]=size(ti);
if (tim~=1)
  error('input argument ti should be (m-by-i)');
end

if (nargin<4)
  error('too few input arguments');
end

if (nargin>4)&~strcmp(method,'hermite')
  warning('too many input arguments');
end

%for now, assume ti is always increasing and within the bounds of t,
%else return NaN or possibly crash
qi=zeros(m,ni)*NaN; 
qid=zeros(m,ni)*NaN;
qidd=zeros(m,ni)*NaN;

%remove values outside the interpolation region
good=find(imdilate((t>=ti(1))|(t<=ti(end)),ones(1,5)));
q=q(:,good);
t=t(good);

switch method
       
  case 'linear'
    disp('TransInterp method: linear');
    for k=1:n-1
        u0=t(k);
        u1=t(k+1);
        
        hot=find((ti>=u0)&(ti<=u1));
        u=(ti(hot)-u0)/(u1-u0);
        
		  if ~isempty(hot)
          qi(:,hot) = q(:,k)*(1-u)+q(:,k+1)*u;
        end
    end  
  

  case 'controlled'
    disp('TransInterp method: controlled');
    tau=0.2; %controller time constant
    options=odeset('MaxStep',tau);
    for k=1:m
      [junk,xi]=ode45('TransInterp_ODE',ti,[q(k,1);0;0],options,t,q(k,:),tau);
      xi=xi';
      qi(k,:)=xi(1,:);
      qid(k,:)=xi(2,:);
      qidd(k,:)=xi(3,:);
    end


  case 'cubic'
    disp('TransInterp method: cubic');
    
    % performs cubic spline interpolation
    %
    % y = a1 + a2*t + a3*t^2 + a4*t^3 with t in range [0,1]
    
    A=diag([2,4*ones(1,n-2),2])+diag(ones(1,n-1),1)+diag(ones(1,n-1),-1);
    B=([q(:,2)-q(:,1),q(:,3:end)-q(:,1:(end-2)),q(:,end)-q(:,(end-1))]*3)';
    D=(inv(A)*B)';
    
    dq=diff(q,1,2);
    
    a=q(:,1:end-1);
    b=D(:,1:end-1);
    c=3*dq-2*b-D(:,2:end);
    d=-2*dq+b+D(:,2:end);
    
    %perform piecewise interpolation for all points within each interval
    for k=1:n-1
        u0=t(k);
        u1=t(k+1);
        
        hot=find((ti>=u0)&(ti<=u1));
        
	 	  if ~isempty(hot)
         du=u1-u0;
	 		u=(ti(hot)-u0)/du;
         qi(:,hot) = a(:,k)*ones(1,length(hot)) + b(:,k)*u + c(:,k)*(u.*u) + d(:,k)*(u.^3);
         qid(:,hot) = (b(:,k)*ones(1,length(hot)) + 2*c(:,k)*u + 3*d(:,k)*(u.*u))/du;
         qidd(:,hot) = (2*c(:,k)*ones(1,length(hot)) + 6*d(:,k)*u)/(du*du);
       end
    end


%  case 'ConstantJerk'
%    disp('TransInterp method: ConstantJerk');
%    
%    qdd=zeros(m,n);
%    qidd=zeros(m,ni);
%    vo=zeros(3,1);
%    A=zeros(n,n);
%    B=zeros(n,1);
%
%    %take care of boundary conditions
%	 A(1,1) = 1;
%	 A(n,n) = 1;
%	 B(1,1) = 0;
%	 B(n,1) = 0;
%
%    for i=1:m 
%      y=q(i,:);
%
%      for j=2:(n-1)
%		  %fill the A matrix
%		  A(j,j-1) = t(j)-t(j-1);
%		  A(j,j) = 2*(t(j+1)-t(j-1));
%		  A(j,j+1) = t(j+1)-t(j);
%
%		  %fill the B vector
%		  B(j,1) = 6*((y(j+1)-y(j))/(t(j+1)-t(j))-(y(j)-y(j-1))/(t(j)-t(j-1)));
%      end
%
%      qdd(i,:)=(inv(A)*B)';
%      qidd(i,:)=interp1(t,qdd(i,:),ti,'linear');
%      
%    end
%    xo=q(:,1);
%    vo=6*((q(:,3)-q(:,2))/(t(3)-t(2))-(q(:,2)-q(:,1))/(t(2)-t(1)));
%
%    [qi,qid]=DoubleIntegrate(qidd,vo,xo,ti);

  otherwise
    error('invalid method');
end

return
