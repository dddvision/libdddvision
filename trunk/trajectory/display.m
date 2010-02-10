% Plot multiple trajectories evaluated at multiple instants
%
% INPUT ARGUMENTS
% this = vector of trajectory objects 
% t = vector of time instants
% s = plot settings
%








function handles=display(this,t,varargin)

if( nargin<3 )
  s={'r-','MarkerSize',1};
else
  s=varargin;
end

K=numel(this);
handles = zeros(K,1);
for k=1:K
  switch( this(k).type )
    case {'tlolah','txyz','analytic'}
      [a,b]=domain(this(k));
      if( nargin>=2 )
        tvalid=t((t>=a)&(t<=b));
      else
        tvalid=a:(b-a)/10000:b;
      end

      if(~isempty(tvalid))        
        state=eval(this(k),tvalid);
        x=state(1,:);
        y=state(2,:);

        % TODO: do something instead of only plotting first two dimensions, reversed
        %z=state(3,:);
        %plot3(x,y,z,s{:});
        handles(k) = plot(y,x,s{:});
        hold('on');
      end

    case 'empty'
      % do nothing
    otherwise
      error('unhandled exception');
  end

end
handles=handles(handles>0);
  
return;
