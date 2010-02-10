function y = RemoveBorders(y,w,v)
%Removes or replaces borders of an image
%
% w = width of border
% v = value to put in border region (default=0)
%








if nargin<3
   v=0;
end

y(:,1:w)=v;
y(:,end-(0:(w-1)))=v;
y(1:w,:)=v;
y(end-(0:(w-1)),:)=v;

return
