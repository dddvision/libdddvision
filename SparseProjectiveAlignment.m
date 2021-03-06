% Computes projective alignment parameters
%
% INPUT
% newImage = image in which to find feature matches for the given high peaks
% highPeaks = one dimensional indices of features in the previous image
% method = the name of a corner computation function
% sigma = method to use when smoothing corners
% numPoints = the maximum number of corners to find in the new image
% numIterations = the number of iterations to use when computing the projective matrix
% mask = logical array that selects regions in the image to process
%
% OUTPUT
% P = projective alignment parameters in the form
%   [[a1 a2 b1]
%    [a3 a4 b2]
%    [c1 c2 1 ]]
% lowPeaks = corners found in the new image
% xyCov = estimate of the covariance of the coordinate transformation on a per pixel basis
%
% NOTES
% The coordinate system origin is at the image center
%
% ALGORITHM
% The Fast Image Matching Algorithm (FIMA) algorithm estimates the continuous coordinate mapping between two images.
% Currently, the algorithm assumes a perspective camera model and a single approximately planar textured surface visible
% in both images. These assumptions allow the mapping to be modeled by eight projective parameters. It implements a
% computational technique that achieves faster execution than the previous state of the art.
%
% The first step in FIMA is to quickly reduce the O(10^6) pixels of each image to a sparse set of O(10^3) salient
% points. This is done using a standard corner detector (Harris1988), followed by application-specific removal of points
% (e.g. near moving targets). Next, FIMA computes the image domain distance transform (BWDIST) of the selected points.
% FIMA then exploits the fact that the gradients of the distance transform point toward its minima. The set of points in
% the first image are reprojected onto the distance transform of the second image based on an initial guess of
% projective parameters. Then, iterative gradient descent with point-wise reprojection is repeated until the points fall
% into the minima. By this method, a set of projective parameters are obtained.
%
% [BWDIST] Maurer, Calvin, Rensheng Qi, and Vijay Raghavan, "A Linear Time Algorithm for Computing Exact Euclidean
% Distance Transforms of Binary Images in Arbitrary Dimensions," IEEE Transactions on Pattern Analysis and Machine
% Intelligence, Vol. 25, No. 2, February 2003, pp. 265-270.
%
% [Harris1988] C. Harris and M. Stephens (1988). "A combined corner and edge detector". Proceedings of the 4th Alvey
% Vision Conference. pp. 147–151.
%
% [Mann1997] Steve Mann and Rosalind W. Picard, "Video Orbits of the Projective Group: A Simple Approach to Featureless
% Estimation of Parameters," IEEE Trans. on Image Processing, v.6, 1997.
%
% A =
% [ x, y, 1, 0, 0, 0, -x*xs, -xs*y]
% [ 0, 0, 0, x, y, 1, -x*ys, -y*ys]
%
% X =
% [a1]
% [a2]
% [b1]
% [a3]
% [a4]
% [b2]
% [c1]
% [c2]
%
% B =
% [xs]
% [ys]
%
% A'*A=
% [     x*x,     x*y,     x,       0,       0,     0,               -x*x*xs,               -x*xs*y]
% [     x*y,     y*y,     y,       0,       0,     0,               -x*xs*y,               -xs*y*y]
% [       x,       y,     1,       0,       0,     0,                 -x*xs,                 -xs*y]
% [       0,       0,     0,     x*x,     x*y,     x,               -x*x*ys,               -x*y*ys]
% [       0,       0,     0,     x*y,     y*y,     y,               -x*y*ys,               -y*y*ys]
% [       0,       0,     0,       x,       y,     1,                 -x*ys,                 -y*ys]
% [ -x*x*xs, -x*xs*y, -x*xs, -x*x*ys, -x*y*ys, -x*ys, x*x*xs*xs + x*x*ys*ys, x*y*xs*xs + x*y*ys*ys]
% [ -x*xs*y, -xs*y*y, -xs*y, -x*y*ys, -y*y*ys, -y*ys, x*y*xs*xs + x*y*ys*ys, xs*xs*y*y + y*y*ys*ys]
%
% A'*B =
% [              x*xs]
% [              xs*y]
% [                xs]
% [              x*ys]
% [              y*ys]
% [                ys]
% [-x*xs*xs - x*ys*ys]
% [-y*xs*xs - y*ys*ys]
% Copyright 2006 David D. Diel, MIT License

function [P,lowPeaks,xyCov]=SparseProjectiveAlignment(newImage,highPeaks,method,sigma,numPoints,numIterations,mask)

if(nargin==0)
  testScale = 1.1;
  method = 'HarrisCorner';
  halfwin = 2;
  sigma = 2;
  numPoints = 100;
  numIterations = 100;
  border = 20;
  yold = double(imread('cameraman.tif'))/255.0;
  y = imresize(yold, testScale);
  y = y(1:size(yold, 1), 1:size(yold, 2));
  mask = RemoveBorders(ones(size(yold)), border);
  [gi, gj] = ComputeDerivatives2(yold);
  kappa = DetectCorners(gi, gj, halfwin, method);
  allPeaks = (kappa==LocalMAX(kappa,[3, 3]));
  allPeaks = allPeaks&mask;
  highPeaks = find(allPeaks);
  [~, ind] = sort(kappa(highPeaks), 'descend');
  highPeaks = highPeaks(ind(1:numPoints));
  tic; [P, lowPeaks, xyCov] = SparseProjectiveAlignment(y, highPeaks, method, sigma, numPoints, numIterations, mask); toc;
  P
  xyCov
  return;
end

% initialize P
P=eye(3);

% get image size
[M,N]=size(newImage);

% compute gradients
[newGradx,newGrady]=ComputeDerivatives2(newImage);

% compute corner intensity
kappa=DetectCorners(newGradx,newGrady,sigma,method);

% find peaks
allPeaks=(kappa==LocalMAX(kappa,[3,3]));

% only select masked region
if(nargin>6)
  allPeaks=allPeaks&mask;
end

% find linear indices of low peaks
peakIndices=find(allPeaks);
[val,ind]=sort(kappa(peakIndices),'descend');
lowPeaks=peakIndices(ind(1:min(numPoints,numel(ind))));

if(~isempty(highPeaks))
  
  % compute image center and bounds
  xc=(M+1)/2;
  yc=(N+1)/2;
  
  % construct low peak image
  lowPeaksImage=false(M,N);
  lowPeaksImage(lowPeaks)=true;
  
  % compute distance to nearest peak
  R=double(bwdist(lowPeaksImage,'euclidean'));
  
  % get image centered coordinates
  [xo,yo]=ind2sub([M,N],highPeaks);
  xo=xo-xc;
  yo=yo-yc;
  
  % solve for projective model
  for k=1:numIterations
    x=xo;
    y=yo;
    den=P(3,1)*x+P(3,2)*y+P(3,3);
    xp=(P(1,1)*x+P(1,2)*y+P(1,3))./den;
    yp=(P(2,1)*x+P(2,2)*y+P(2,3))./den;
    
    % convert to array coordinates
    xp=xp+xc;
    yp=yp+yc;
    
    % stay within borders
    good=(xp>1)&(xp<M)&(yp>1)&(yp<N);
    xp=xp(good);
    yp=yp(good);
    
    % exclude features that are badly mismatched
    good=(R(sub2ind([M,N],floor(xp+0.5),floor(yp+0.5)))<(3*sigma));
    xp=xp(good);
    yp=yp(good);
    
    xf=floor(xp);
    yf=floor(yp);
    xr=xp-xf;
    yr=yp-yf;
    
    base=xf+M*(yf-1);
    R00=R(base);
    R10=R(base+1);
    R01=R(base+M);
    R11=R(base+(M+1));
    
    % interpolates the derivative of 0.5R^2 by solving the following problem
    % 0.5*R(x,y)^2=0.5*x^2+0.5*y^2+a*x+b*y+c*x*y+d;
    
    R00=0.5*R00.*R00;
    R10=0.5*R10.*R10;
    R01=0.5*R01.*R01;
    R11=0.5*R11.*R11;
    
    aa=R10-R00-0.5;
    bb=R01-R00-0.5;
    cc=R00+R11-R10-R01;
    % dd=R00;
    
    SDRxi=xr+aa+cc.*yr;
    SDRyi=yr+bb+cc.*xr;
    
    % minimize the SAD instead of the SSD
    ADRxi=sqrt(abs(SDRxi));
    ADRyi=sqrt(abs(SDRyi));
    
    % restore the sign
    HSRxi=sign(SDRxi).*ADRxi;
    HSRyi=sign(SDRyi).*ADRyi;
    
    % convert to image centered coordinates
    xp=xp-xc;
    yp=yp-yc;
    
    xs=xp-HSRxi;
    ys=yp-HSRyi;
    
    % shift to relative coordinates
    x=xp;
    y=yp;
    
    % normalize coordinates
    x=x/N;
    y=y/N;
    xs=xs/N;
    ys=ys/N;
    
    xx=x.*x;
    xy=x.*y;
    yy=y.*y;
    xsxs=xs.*xs;
    ysys=ys.*ys;
    xxs=x.*xs;
    yxs=y.*xs;
    xys=x.*ys;
    yys=y.*ys;
    xxxs=xx.*xs;
    xxys=xx.*ys;
    xyxs=xy.*xs;
    xyys=xy.*ys;
    yyys=yy.*ys;
    yyxs=yy.*xs;
    xxsxs=x.*xsxs;
    xysys=x.*ysys;
    yxsxs=y.*xsxs;
    yysys=y.*ysys;
    xxxsxs=xx.*xsxs;
    yyysys=yy.*ysys;
    xxysys=xx.*ysys;
    yyxsxs=yy.*xsxs;
    xyxsxs=xy.*xsxs;
    xyysys=xy.*ysys;
    
    A=zeros(8,8);
    
    A(1,1)=sum(xx);
    A(1,2)=sum(xy);
    A(1,3)=sum(x);
    
    A(2,1)=A(1,2);
    A(2,2)=sum(yy);
    A(2,3)=sum(y);
    
    A(3,1)=A(1,3);
    A(3,2)=A(2,3);
    A(3,3)=numel(x);
    
    A(4:6,4:6)=A(1:3,1:3);
    
    A(7,1)=-sum(xxxs);
    A(7,2)=-sum(xyxs);
    A(7,3)=-sum(xxs);
    A(7,4)=-sum(xxys);
    A(7,5)=-sum(xyys);
    A(7,6)=-sum(xys);
    
    A(8,1)=A(7,2);
    A(8,2)=-sum(yyxs);
    A(8,3)=-sum(yxs);
    A(8,4)=A(7,5);
    A(8,5)=-sum(yyys);
    A(8,6)=-sum(yys);
    
    A(1:6,7:8)=transpose(A(7:8,1:6));
    
    A(7,7)=sum(xxxsxs+xxysys);
    A(7,8)=sum(xyxsxs+xyysys);
    A(8,7)=A(7,8);
    A(8,8)=sum(yyxsxs+yyysys);
    
    B=zeros(8,1);
    
    B(1)=sum(xxs);
    B(2)=sum(yxs);
    B(3)=sum(xs);
    B(4)=sum(xys);
    B(5)=sum(yys);
    B(6)=sum(ys);
    B(7)=-sum(xxsxs+xysys);
    B(8)=-sum(yxsxs+yysys);
    
    if((nargout>2)&&(k==numIterations))
      xyCov = cov([HSRxi,HSRyi]);
    end
    
    if(condest(A)<(1.0/(1000.0*eps)))
      X=A\B;
      
      dP=[[X(1),X(2),X(3)]
        [X(4),X(5),X(6)]
        [X(7),X(8),   1]];
      
      % undo normalization
      dP(1:2,3)=dP(1:2,3)*N;
      dP(3,1:2)=dP(3,1:2)/N;
    else
      dP = eye(3);
    end
    
    % undo relative coordinates
    P=dP*P;
    P=P/P(9);
  end
end

end

% Computes the gradients of one or two arrays
% Uses a 4-element finite difference approximation
% Optionally computes the corresponding difference between arrays
% Removes one-pixel borders that do not make sense by convolution
%
%    y = array (m-by-n)
% yref = reference array (m-by-n)
%   fi = row gradient (m-by-n)
%   fj = column gradient (m-by-n)
%   ft = corresponding array differences (m-by-n)
function [fi,fj,ft]=ComputeDerivatives2(y,yref)

if (size(y,3)~=1)
  error('input must be a 2-dimensional array');
end

if nargin==2
  if (size(y,1) ~= size(yref,1)) || (size(y,2) ~= size(yref,2))
    error('input arrays must be of equal size');
  end
  if (size(yref,3)~=1)
    error('input must be a 2-dimensional array');
  end
end

imask=[
  0  0  0;
  0 -1 -1;
  0  1  1]/2;

jmask=[
  0  0  0;
  0 -1  1;
  0 -1  1]/2;

fi=filter2(imask,y);
fj=filter2(jmask,y);

fi=RemoveBorders(fi,1);
fj=RemoveBorders(fj,1);

if nargin==2
  tmask=[
    0  0  0;
    0  1  1;
    0  1  1]/4;
  ft=filter2(tmask,y)+filter2(-tmask,yref);
  ft=RemoveBorders(ft,1);
else
  ft=[];
end

end

%Removes or replaces borders of an image
%
% w = width of border
% v = value to put in border region (default=0)
function y = RemoveBorders(y,w,v)

if nargin<3
  v=0;
end

y(:,1:w)=v;
y(:,end-(0:(w-1)))=v;
y(1:w,:)=v;
y(end-(0:(w-1)),:)=v;

end

function kappa=DetectCorners(gi,gj,halfwin,method)

win=(2*halfwin+1)*[1,1];

%formulate the gradient products
gxx=gi.*gi;
gyy=gj.*gj;
gxy=gi.*gj;

%Perform smoothing or local sum
xx=Smooth2(gxx,win,halfwin/4);
yy=Smooth2(gyy,win,halfwin/4);
xy=Smooth2(gxy,win,halfwin/4);

%calculate corner intensity
kappa=feval(method,xx,yy,xy);

end

% Performs gaussian smoothing over a window
%
% I=intensity image
% sig=smoothing factor
% OUT=output image
function OUT=Smooth2(I,win,sig)
M=fspecial('gaussian',win,sig);
OUT=filter2(M,I);
end

% The corner detector of Harris and Stephens
% based on the symmetric 2x2 matrix
% [xx xy]
% [xy yy]
%
% Where xx,yy,xy are sums of local image gradients
function val=HarrisCorner(xx,yy,xy)
val=(xx.*yy-xy.*xy)./(xx+yy+eps);
end

% LocalMAX() calculates the local maximum using a sliding window
%
% win(1) is the height of the window
% win(2) is the width of the window
function I=LocalMAX(I,win)
I=colfilt(I,win,'sliding','max');
end
