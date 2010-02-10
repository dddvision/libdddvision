% Apply a rotation matrix to a trajectory
%








function this=rotate(this,R)

switch( this.type )
  case 'txyz'
    this.data(2:4,:)=R*this.data(2:4,:);
  case {'empty','analytic'}
    % do nothing
  otherwise
    error('unhandled exception');
end

return;
