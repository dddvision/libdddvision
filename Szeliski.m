function [M] = Szeliski(I,Iold,itr,wt)
%
%
% NON-FUNCTIONAL AT THIS TIME
%
%
% Szeliski() finds projective parameters given two images
%
% M=[a1;a2;a3;a4;b1;b2;c1;c2];
% itr is the number of iterations
% mask is a weight(x,y) image to be applied to the old(x,y) image
% Copyright 2002 David D. Diel, MIT License

if nargin==4
    [R,T]=Anandan2(I,Iold,3,3,wt);
else
    [R,T]=Anandan2(I,Iold,3,3);
end

M=[R(1);R(3);R(2);R(4);T(1);T(2);0;0];

warped=Warp3(Iold,M);
[fx,fy,e]=ComputeDerivatives2(I,warped);
%[fy,fx]=gradient(warped);
%e=warped-I;

[J1,J2,J3,J4,J5,J6,J7,J8]=ComputeJacobians(e,M,fx,fy);    

%J=[sum(J1(:)),sum(J2(:)),sum(J3(:)),sum(J4(:)),sum(J5(:)),sum(J6(:)),sum(J7(:)),sum(J8(:))];

J=[sum(J7(:)),sum(J8(:))];

A=J'*J;

% b=-[sum(e(:).*J1(:));
%     sum(e(:).*J2(:));
%     sum(e(:).*J3(:));
%     sum(e(:).*J4(:));
%     sum(e(:).*J5(:));
%     sum(e(:).*J6(:));
%     sum(e(:).*J7(:));
%     sum(e(:).*J8(:))];

b=-[sum(e(:).*J7(:));
    sum(e(:).*J8(:))];

ERR=sum(e(:));
lam=0.001;

for i=1:itr
    dM=[0;0;0;0;0;0;inv(A+lam*eye(2))*b];
    
    warped_new=Warp3(Iold,M+dM);
    [fx,fy,e]=ComputeDerivatives2(I,warped_new);
    ERR_new=sum(e(:).*e(:));
    
    if ERR_new<ERR
        ERR=ERR_new;
        M=M+dM;
        lam=lam/10;
        disp('iteration successful');
    else
        lam=lam*10;
        disp('iteration failed');
        disp(A);
        disp(b);
    end 
end
return


function [J1,J2,J3,J4,J5,J6,J7,J8]=ComputeJacobians(I,M,fx,fy)

if (size(I,3)~=1)
   error('method only works for gray-level images');
end;

[m,n]=size(I);
[y,x]=meshgrid(1:n,1:m);

c=(M(7)*x+M(8)*y+1);
ab1=(M(1)*x+M(2)*y+M(5));
ab2=(M(3)*x+M(4)*y+M(6));

J1=fx.*x./c;
J2=fx.*y./c;
J3=fy.*x./c;
J4=fy.*y./c;
J5=fx./c;
J6=fy./c;
J7=(-J1.*ab1-J3.*ab2)./c;
J8=(-J2.*ab1-J4.*ab2)./c;

return