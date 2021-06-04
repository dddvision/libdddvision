% Crops and pads image borders
%
% y = image
% crop = border pixels to remove around the image (can be negative)
% pad = padding pixels to add around the image
% value = value to put in the pad region (default=0)
% Copyright 2002 University of Central Florida, MIT License
function y = AdjustBorders(y,crop,pad,value)

if nargin<4
  value=0;
end

if crop==pad
  y(:,1:pad)=value;
  y(:,end-(0:(pad-1)))=value;
  y(1:pad,:)=value;
  y(end-(0:(pad-1)),:)=value;
  
else
  [m,n]=size(y);
  
  A=value*ones(m-2*crop,pad);
  B=value*ones(pad,n-2*crop);
  C=value*ones(pad,pad);
  D=y((1+crop):(m-crop),(1+crop):(n-crop));
  
  y=[C,B,C;A,D,A;C,B,C];
end

end
