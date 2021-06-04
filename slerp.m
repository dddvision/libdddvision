% hyper-spherical linear interpolation
%
% ARGUMENTS:
%   qa = initial orientation (4-by-N)
%   qb = final orientation (4-by-N)
%    u = interpolation points (0 to 1) (scalar or 1-by-N)
% mode = 'sinusoidal' or 'polynomial' modified versions
%
% RETURN VALUES:
% Q = interpolated quaternions (4-by-n)
% Public Domain


function Q=slerp(qa,qb,u,mode)

%define a small number
ep=1E-12;

%check input arguments
[m,n]=size(qa);
[bm,bn]=size(qb);

if (m~=4)|(bm~=4)|(n~=bn)
  error('both input quaternions must 4-by-n)');
end

[um,un]=size(u);
if (um~=1)|(un~=n)
  if (um~=1)|(un~=1)
    error('argument u must be scalar or 1-by-n');
  end
end

%optionally modify the spacing
if nargin>3
	switch mode
	case 'sinusoidal'
		disp('slerp: sinusoidal mode');
		u=u-sin(2*pi*u)/(2*pi);
	case 'polynomial'
		disp('slerp: polynomial mode');
		u=10*u.^3-15*u.^4+6*u.^5;
	otherwise
    disp('slerp: linear mode');
	end
else
	%quiet linear mode
end

%extract angle between 4-D vectors
th=acos(dot(qa,qb));
st=sin(th);

%handle small values of theta
bad=find(abs(st)<ep);
sgn=sign(st(bad));
sgn(sgn==0)=1;
st(bad)=sgn*ep;
th(bad)=sgn*ep;

%formulate the answer
Q=qa.*(ones(4,1)*(sin((1-u).*th)./st))+qb.*(ones(4,1)*(sin(u.*th)./st));

return