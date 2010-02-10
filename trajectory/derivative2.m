% Evaluate the second derivative of a trajectory at multiple instants
%









function dxdt=derivative2(this,t)

switch( this.type )
  case 'analytic'
    dxdt=eval(this.data.derivative2);
  case {'tlolah','txyz'}
    N=numel(t);
    dt=(this.data(1,end)-this.data(1,1))/(N-1);
    tmm=t-2*dt;
    tm=t-dt;
    tp=t+dt;
    tpp=t+2*dt;
    xmm=eval(this,tmm);
    xm=eval(this,tm);
    x=eval(this,t);
    xp=eval(this,tp);
    xpp=eval(this,tpp);
    dxdt=(-xmm+16*xm-30*x+16*xp-xpp)/(12*dt^2);
  case 'empty'
    dxdt=[];
  otherwise
    error('unhandled exception');
end

return;
