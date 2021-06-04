% Searches for a logical true element by spiraling out from a starting point
% 
% INPUT
% h = array to search within
% ijo = starting point, 2-by-1
% 
% OUTPUT
% ij = nearby indices of true element, 2-by-1
% Copyright 2006 David D. Diel, MIT License
function ij = spiralsearch(h,ijo)

[I,J]=size(h);
i = ijo(1);
j = ijo(2);
ij=zeros(2,0);

% spiral out
spiral_step('reset');
while( (i>0)&&(i<=I)&&(j>0)&&(j<=J) )
  % fprintf('\n%d,%d',i,j);
  if( h(i,j) )
    ij = [i;j];
    break;
  end
  [i,j]=spiral_step(i,j);
end

end


function [i,j]=spiral_step(i,j)

persistent B b bin dir

% initialization
if( nargin<2 )
  B=1;
  b=0;
  bin=0;
  dir=0;
  return;
end

% apply state
switch( dir )
  case 0
    i=i+1;
  case 1
    j=j+1;
  case 2
    i=i-1;
  case 3
    j=j-1;
end

% advance direction state on block rollover
if( b==0 )
  dir = mod(dir+1,4);
  
  % advance block on second rollover
  if( bin==1 )
    B=B+1;
  end

  % advance binary count state
  bin = mod(bin+1,2);
  
end

% advance block count state
b = mod(b+1,B);

end

% % subsequent ridge finding
% while( (i>1)&&(i<I)&&(j>1)&&(j<J) )
%   sub = h(i+win,j+win);  
%   maxs = max(sub(:));
%   ind = find(sub==maxs);
%   if( numel(ind)>1 )
%     break;
%   end
%   switch( ind )
%     case 1
%       i=i-1;
%       j=j-1;
%     case 2
%       j=j-1;
%     case 3
%       i=i+1;
%       j=j-1;
%     case 4
%       i=i-1;
%     case 5
%       break;
%     case 6
%       i=i+1;
%     case 7
%       i=i-1;
%       j=j+1;
%     case 8
%       j=j+1;
%     case 9
%       i=i+1;
%       j=j+1;
%   end
% end
