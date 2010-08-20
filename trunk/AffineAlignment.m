% Finds affine parameters to transform the old image into the new one
%
% INPUT
% new = new image
% old = old image
% level = specifies how many pyramid levels to use
% itr = number of iterations per level
% mask = weight(x,y) image to be applied to the old(x,y) image

% OUTPUT
% M = affine alignment parameters in the form
%   [[a1 a2 b1]
%    [a3 a4 b2]
%    [ 0  0 1 ]];

function M = AffineAlignment(new,old,level,itr,M,mask)

  I=cell(level,1);
  Iold=cell(level,1);

  I{1}=new;
  Iold{1}=old;
  if(nargin==6)
    w=cell(level,1);
    w{1}=double(mask);
  end

  %create pyramid
  for i=2:level
    I{i}=Reduce(I{i-1});
    Iold{i}=Reduce(Iold{i-1});
    if(nargin==6)
      w{i}=Reduce(w{i-1});
    end

    M(1:2,3)=M(1:2,3)/2;
  end

  for i=level:-1:1
    [m,n]=size(Iold{i});
    [xg,yg]=ndgrid(((1-m)/2):((m-1)/2),((1-n)/2):((n-1)/2));

    if i~=level
        M(1:2,3)=M(1:2,3)*2;
    end

    for j=1:itr
      warped=Warp3(Iold{i},M);  

      %removing saturated regions
      temp=(warped<0.05)|(warped>0.95);
      temp=imdilate(temp,ones(3));
      bad=find(temp);

      [fxp,fyp,ftp]=ComputeDerivatives2(I{i},warped);    

      fxp(bad)=0;
      fyp(bad)=0;
      ftp(bad)=0;

      %residual motion
      %figure(1),imshow(abs(ftp)./sqrt(fxp.*fxp+fyp.*fyp));

      if nargin==6
        wi=find(w{i}(:)>0.5);

        x=xg(wi);
        y=yg(wi);

        fx=fxp(wi);
        fy=fyp(wi);
        ft=ftp(wi);
      else
        x=xg(:);
        y=yg(:);

        fx=fxp(:);
        fy=fyp(:);
        ft=ftp(:);
      end

      a1 = x.*fx;
      a2 = y.*fx;
      a3 = fx;
      a4 = x.*fy;
      a5 = y.*fy;
      a6 = fy;

      A(1,1) = sum(a1.*a1);
      A(1,2) = sum(a1.*a2);
      A(1,3) = sum(a1.*a3);
      A(1,4) = sum(a1.*a4);
      A(1,5) = sum(a1.*a5);
      A(1,6) = sum(a1.*a6);

      A(2,1) = A(1,2);
      A(2,2) = sum(a2.*a2);
      A(2,3) = sum(a2.*a3);
      A(2,4) = A(1,5);
      A(2,5) = sum(a2.*a5);
      A(2,6) = sum(a2.*a6);

      A(3,1) = A(1,3);
      A(3,2) = A(2,3);
      A(3,3) = sum(a3.*a3);
      A(3,4) = A(1,6);
      A(3,5) = A(2,6);
      A(3,6) = sum(a3.*a6);

      A(4,1) = A(1,4);
      A(4,2) = A(2,4);
      A(4,3) = A(3,4);
      A(4,4) = sum(a4.*a4);
      A(4,5) = sum(a4.*a5);
      A(4,6) = sum(a4.*a6);

      A(5,1) = A(1,5);
      A(5,2) = A(2,5);
      A(5,3) = A(3,5);
      A(5,4) = A(4,5);
      A(5,5) = sum(a5.*a5);
      A(5,6) = sum(a5.*a6);

      A(6,1) = A(1,6);
      A(6,2) = A(2,6);
      A(6,3) = A(3,6);
      A(6,4) = A(4,6);
      A(6,5) = A(5,6);
      A(6,6) = sum(a6.*a6);

      E=a1+a5-ft;
      
      B(1,1) = sum(E.*a1);
      B(2,1) = sum(E.*a2);
      B(3,1) = sum(E.*a3);
      B(4,1) = sum(E.*a4);
      B(5,1) = sum(E.*a5);
      B(6,1) = sum(E.*a6);

      if condest(A)>(10^16);
        disp('projective calculation may be inaccurate');   
      end

      p=A\B;

      dM=[[p(1),p(2),p(3)]
         [ p(4),p(5),p(6)]
         [    0,   0,   1]];
        
      M=dM*M;
      M=M/M(9);
    end
  end
end
