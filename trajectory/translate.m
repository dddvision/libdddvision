% Apply translation to a trajectory
%








function this=translate(this,T)

switch( this.type )
  case 'txyz'
    this.data(2:4,:)=this.data(2:4,:)+repmat(T,[1,size(this.data,2)]);
  case {'empty','analytic'}
    % do nothing
  otherwise
    error('unhandled exception');
end

return;
