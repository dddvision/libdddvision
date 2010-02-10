% Evaluate the first derivative of a trajectory at multiple instants
%









function dxdt=derivative(this,t)

switch( this.type )
  case 'analytic'
    dxdt=eval(this.data.derivative);
  case {'tlolah','txyz'}
    N=numel(t);
    dt=1e-9;
    tm=t-dt;
    tp=t+dt;
    xm=eval(this,tm);
    xp=eval(this,tp);
    dxdt=(xp-xm)/(2*dt);
  case 'empty'
    dxdt=[];
  otherwise
    error('unhandled exception');
end

return;
