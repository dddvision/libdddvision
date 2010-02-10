% Construct an individual typed trajectory
%
% INPUT ARGUMENTS
% type = string that identifies a user-defined trajectory type
% data = formatted data that represents the user-defined type
%
% RETURN VALUE
% this = new trajectory object
%









function this=trajectory(type,data)

if( nargin==0 )
  this=class(struct('type',{},'data',{}),'trajectory');
  return;
end

switch( type )
  case 'trajectory'
    this=data;
  case {'gotcha','geko','analytic'}
    this=struct('type',type,'data',data);
  case {'tlolah','txyz'}
    % discard data with non-increasing time indices
    data=data(:,logical([1,diff(data(1,:))>eps]));
    this=struct('type',type,'data',data);
  case 'empty'
    % data is empty set
    this=struct('type',type,'data',[]);
  otherwise
    error('unhandled exception');
end

this=class(this,'trajectory');

return;
