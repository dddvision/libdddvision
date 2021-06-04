function [Qddav,Qdav,Qav]=PathAverage(Qt,ti)
% Copyright 2006 David D. Diel, MIT License

%precision for Qav
%Qddav and Qdav are accurate to machine precision
PRECISION=6;

m=size(Qt,1);
n=size(ti,2);

dt=ones(m,1)*diff(ti,1,2);

%acceleration
Qtd=diff(Qt,'t');
Qd=zeros(m,n);
for i=1:m
  Qd(i,:)=feval(vectorize(inline(char(Qtd(i)))),ti);
end
Qddav=diff(Qd,1,2)./dt;

%velocity  
if (nargout>=2)
  Q=zeros(m,n);
  for i=1:m
    Q(i,:)=feval(vectorize(inline(char(Qt(i)))),ti);
  end
  Qdav=diff(Q,1,2)./dt;
end

%position
if (nargout==3)
  try
    %don't even try to explicitly integrate quaternions
    Qint=zeros(m,n);
    options=odeset('RelTol',10^(-PRECISION),'AbsTol',10^(-PRECISION));
    for i=1:m
      [junk,Qintp]=ode113('PathAverage_ODE',ti,0,options,Qt(i));
      Qint(i,:)=Qintp';
    end
    Qav=diff(Qint,1,2)./dt;
    den=sqrt(Qav(1,:).*Qav(1,:) + Qav(2,:).*Qav(2,:) + Qav(3,:).*Qav(3,:) + Qav(4,:).*Qav(4,:));
    for i=1:4
      Qav(i,:)=Qav(i,:)./den;
    end

  catch
    warning('Numerical integration failed.  Approximating average states during each time step.');
    qT=(Q(5:7,1:(end-1))+Q(5:7,2:end))/2; 
    qR=slerp(Q(1:4,1:(end-1)),Q(1:4,2:end),0.5);
    Qav=[qR;qT];
  end
end

return
