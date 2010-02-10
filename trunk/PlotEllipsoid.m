function handle=PlotEllipsoid(mu,covar,dev,c)
% Plots a semi-transparent covariance ellipsoid in the current axis
%
% INPUT ARGUMENTS:
%    mu = mean (3-by-1)
% covar = covariance matrix (3-by-3)
%   dev = (optional) surface represents this number of standard deviations (1-by-1)
%     c = (optional) color (1-by-1)
%
% RETURN ARGUMENT:
% handle = handle to the ellipsoid object

% assumed level of detail for mesh
N=20;
Np=N+1;

[m,n]=size(mu);
if (m~=3)|(n~=1)
  error('first argument must be (3-by-1)');
end

[m,n]=size(covar);
if (m~=3)|(n~=3)
  error('second argument must be (3-by-3)');
end

if nargin<3
  dev=1;
else
  [m,n]=size(dev);
  if (m~=1)|(n~=1)
    error('third argument must be (1-by-1)');
  end
end

if nargin<4
  c=0.5;
else 
  [m,n]=size(c);
  if (m~=1)|(n~=1)
    error('fourth argument must be (1-by-1)');
  end
end

%create prototypical surface
[xo,yo,zo]=sphere(N);

%check for exact singularity
if det(covar)==0
  handle=[];
  return;
end

%extract matrix sqrt, adjusted by deviation
W=sqrtm(covar)*dev;

%scale, rotate, and shift
X=W*[xo(:)';yo(:)';zo(:)']+mu*ones(1,Np*Np);

%reassemble
x=reshape(X(1,:),[Np,Np]);
y=reshape(X(2,:),[Np,Np]);
z=reshape(X(3,:),[Np,Np]);

%plot the ellipsoid
handle=surface(x,y,z,c*ones(Np,Np),'EdgeColor','n');
alpha(handle,0.3)

return