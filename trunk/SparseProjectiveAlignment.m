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

function [P,lowPeaks]=SparseProjectiveAlignment(newImage,highPeaks,method,sigma,numPoints,numIterations)

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
  
  % find high and somewhat high peaks
  peakIndices=find(allPeaks);
  [val,ind]=sort(kappa(peakIndices),'descend');
  lowPeaks=peakIndices(ind(1:min(numPoints,numel(ind))));
  
  if(~isempty(highPeaks))
  
    % construct low peak image
    lowPeaksImage=false(M,N);
    lowPeaksImage(lowPeaks)=true;

    % compute distance to nearest peak
    R=double(bwdist(lowPeaksImage,'euclidean'));

    % compute half squared distance
    HSR=0.5*(R.*R);

    % compute gradients of half squared distance
    [HSRy,HSRx]=gradient(HSR);
    %[HSRx,HSRy]=ComputeDerivatives2(HSR);
  
    % solve for projective model
    [xo,yo]=ind2sub([M,N],highPeaks); 
    for k=1:numIterations
      x=xo;
      y=yo;
      den=P(3,1)*x+P(3,2)*y+P(3,3);
      xp=(P(1,1)*x+P(1,2)*y+P(1,3))./den;
      yp=(P(2,1)*x+P(2,2)*y+P(2,3))./den;
      xp=floor(xp+0.5);
      yp=floor(yp+0.5);

      % stay within borders by at least 1 pixel
      good=(xp>1)&(xp<M)&(yp>1)&(yp<N);
      xp=xp(good);
      yp=yp(good);
      x=x(good);
      y=y(good);
      
      % convert indices
      ip=sub2ind([M,N],xp,yp);
      
      % exclude features that are badly mismatched
      good=(R(ip)<(3*sigma));
      xp=xp(good);
      yp=yp(good);
      x=x(good);
      y=y(good);
      ip=ip(good);

      HSRxi=HSRx(ip);
      HSRyi=HSRy(ip);
      xs=xp-HSRxi;
      ys=yp-HSRyi;
      
      A=zeros(8,8);
      B=zeros(8,1);
      
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
      
      B(1)=sum(xxs);
      B(2)=sum(yxs);
      B(3)=sum(xs);
      B(4)=sum(xys);
      B(5)=sum(yys);
      B(6)=sum(ys);
      B(7)=-sum(xxsxs+xysys);
      B(8)=-sum(yxsxs+yysys);

      X=A\B;
      P=[X(1),X(2),X(3);X(4),X(5),X(6);X(7),X(8),1];
    end
  end

end
