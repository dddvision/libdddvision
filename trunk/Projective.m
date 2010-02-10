function [M] = Projective(new,old,level,itr,M,mask)
% M=Projective() finds affine parameters to transform the old image into the new one
%
% M=[[a1 a2 b1]
%    [a3 a4 b2]
%    [c1 c2 1 ]];
% level specifies how many pyramid levels to use
% itr is the number of iterations per level
% mask is a weight(x,y) image to be applied to the old(x,y) image
%
%Copyright David D. Diel Dec. 3, 2001
%all rights reserved

I{1}=new;
Iold{1}=old;
if nargin==6 w{1}=double(mask);end

%create pyramids
for i=2:level
    I{i}=Reduce(I{i-1});
    Iold{i}=Reduce(Iold{i-1});
    if nargin==6 w{i}=Reduce(w{i-1});end
    
    M(:,3)=0.5*M(:,3);
    M(3,:)=2*M(3,:);
end

for i=level:-1:1
    [m,n]=size(Iold{i});
    [yg,xg]=meshgrid(((1-n)/2):((n-1)/2),((1-m)/2):((m-1)/2));
    
    if i~=level
        M(:,3)=2*M(:,3);
        M(3,:)=0.5*M(3,:);
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
        a7 = x.*ft-x.*a1-y.*a4;
        a8 = y.*ft-x.*a2-y.*a5;
        
        A(1,1) = sum(a1.*a1);
        A(1,2) = sum(a1.*a2);
        A(1,3) = sum(a1.*a3);
        A(1,4) = sum(a1.*a4);
        A(1,5) = sum(a1.*a5);
        A(1,6) = sum(a1.*a6);
        A(1,7) = sum(a1.*a7);
        A(1,8) = sum(a1.*a8);
        
        A(2,1) = A(1,2);
        A(2,2) = sum(a2.*a2);
        A(2,3) = sum(a2.*a3);
        A(2,4) = A(1,5);
        A(2,5) = sum(a2.*a5);
        A(2,6) = sum(a2.*a6);
        A(2,7) = sum(a2.*a7);
        A(2,8) = sum(a2.*a8);
        
        A(3,1) = A(1,3);
        A(3,2) = A(2,3);
        A(3,3) = sum(a3.*a3);
        A(3,4) = A(1,6);
        A(3,5) = A(2,6);
        A(3,6) = sum(a3.*a6);
        A(3,7) = sum(a3.*a7);
        A(3,8) = sum(a3.*a8);
        
        A(4,1) = A(1,4);
        A(4,2) = A(2,4);
        A(4,3) = A(3,4);
        A(4,4) = sum(a4.*a4);
        A(4,5) = sum(a4.*a5);
        A(4,6) = sum(a4.*a6);
        A(4,7) = sum(a4.*a7);
        A(4,8) = sum(a4.*a8);
        
        A(5,1) = A(1,5);
        A(5,2) = A(2,5);
        A(5,3) = A(3,5);
        A(5,4) = A(4,5);
        A(5,5) = sum(a5.*a5);
        A(5,6) = sum(a5.*a6);
        A(5,7) = sum(a5.*a7);
        A(5,8) = sum(a5.*a8);
        
        A(6,1) = A(1,6);
        A(6,2) = A(2,6);
        A(6,3) = A(3,6);
        A(6,4) = A(4,6);
        A(6,5) = A(5,6);
        A(6,6) = sum(a6.*a6);
        A(6,7) = sum(a6.*a7);
        A(6,8) = sum(a6.*a8);
        
        A(7,1) = A(1,7);
        A(7,2) = A(2,7);
        A(7,3) = A(3,7);
        A(7,4) = A(4,7);
        A(7,5) = A(5,7);
        A(7,6) = A(6,7);
        A(7,7) = sum(a7.*a7);
        A(7,8) = sum(a7.*a8);
        
        A(8,1) = A(1,8);
        A(8,2) = A(2,8);
        A(8,3) = A(3,8);
        A(8,4) = A(4,8);
        A(8,5) = A(5,8);
        A(8,6) = A(6,8);
        A(8,7) = A(7,8);
        A(8,8) = sum(a8.*a8);
        
        E=a1+a5-ft;
        
        B(1,1) = sum(E.*a1);
        B(2,1) = sum(E.*a2);
        B(3,1) = sum(E.*a3);
        B(4,1) = sum(E.*a4);
        B(5,1) = sum(E.*a5);
        B(6,1) = sum(E.*a6);
        B(7,1) = sum(E.*a7);
        B(8,1) = sum(E.*a8);
        
        if condest(A)>(10^16);
            disp('projective calculation may be inaccurate');   
        else
            p=inv(A)*B;
        
            dM=[p(1),p(2),p(3);
            p(4),p(5),p(6);
            p(7),p(8),1   ];

            %update method can be derived using homogenous coordinates
            M=dM*M;
            M=M/M(9);
        end
    end
end
return