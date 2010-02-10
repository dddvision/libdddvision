% Evaluate a trajectory at multiple instants
%









function x=eval(this,t)

[a,b]=domain(this);

switch( this.type )
  case {'tlolah','txyz'}
    if( isempty(t) )
      x=zeros(3,0);
    else
      t(t<a)=a;
      t(t>b)=b;
      x=interp1(this.data(1,:),this.data(2:end,:)',t,'linear')';
    end
  case 'analytic'
    x=eval(this.data.eval);
  case 'empty'
    x=[];
  otherwise
    error('unhandled exception');
end

return;
