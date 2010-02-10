function xidot=TransInterp_ODE(ti,xi,junk,T,X,tau)
% tau = control time constant
%
% system model
% xdd = -2*zeta*wn*xd -wn^2*(x-xD) 
% assume critical damping 

x=xi(1);
xd=xi(2);
xdd=xi(3);

%desired position by linear interpolation
p=find(ti<T);
if isempty(p)
  xD=X(end);
  xdD=0;
else
  p=p(1);
  m=p-1;

  Tm=T(m);
  Tp=T(p);
  Xm=X(m);
  Xp=X(p);

  slope=(Xp-Xm)/(Tp-Tm);

  xD=Xm+(ti-Tm)*slope;
  xdD=slope;
end

%virtual dynamics
wn=2*pi/tau;
wn2=wn*wn;
xddd=-2*wn*xdd-wn2*(xd-xdD);
xdd=-2*wn*xd-wn2*(x-xD);

xidot=[xd;xdd;xddd];

return