% Return the domain of a trajectory
%









function [a,b]=domain(this)

switch( this.type )
  case {'tlolah','txyz'}
    a=this.data(1,1);
    b=this.data(1,end);
  case 'analytic'
    a=eval(this.data.domain.a);
    b=eval(this.data.domain.b);
  case 'empty'
    a=[];
    b=[];
  otherwise
  error('unhandled exception');
end

return;
