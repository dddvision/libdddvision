% Apply gaussian smoothing to a trajectory
%








function this=smooth(this,sigma)

switch( this.type )
  case {'tlolah','txyz'}
    pad=floor(2*sigma);
    kernel=fspecial('gaussian',[1,1+2*pad],sigma);
    pre=repmat(this.data(:,1),[1,pad]);
    aft=repmat(this.data(:,end),[1,pad]);
    this.data=conv2([pre,this.data,aft],kernel,'valid');
  case {'empty','analytic'}
    % do nothing
  otherwise
    error('unhandled exception');
end

return;
