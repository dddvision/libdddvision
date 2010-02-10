% Colormap of BLACK-BLUE-GREEN-YELLOW-WHITE used for RADAR & SAR
%
% INPUT
% row = index of a color row (optional)
%
% OUTPUT
% f	= an 8-bit colormap or a single color row
% 
% CREDITS
% Goodyear Aerospace
% MIT Lincoln Laboratory
% Frost Technical Services
% Scientific Systems Company
function f = radar(row)
  f = zeros(256,3);

  %  construct red
  f(80:191,1) = 0.9961*(0:111)'/111;
  f(192:256,1) = 0.9961*ones(65,1);

  %  construct green
  f(3:256,2) = 0.9844*(0:253)'/253;

  %  construct blue
  f(1:20,3) = 0.2344*(0:19)'/19;
  f(21:30,3) = 0.2344 + 0.039*(0:9)'/9;
  f(31:40,3) = 0.2734 - 0.039*(0:9)'/9;
  f(41:80,3) = 0.2344 - 0.2344*(0:39)'/39;
  f(180:245,3) = 0.9961*(0:65)'/65;
  f(246:256,3) = 0.9961*ones(11,1);

  if( nargin==1 )
    f=f(row,:);
  end
end

