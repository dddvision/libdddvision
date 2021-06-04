function [T,X,Xd,Q,Qd,n]=ReadNavDat(datafile)
%tested for intuitive correctness, but not for numerical correctness
% Copyright 2006 David D. Diel, MIT License

rawdata=dlmread(datafile,' ');
rawdata=rawdata(:,1:10)';

[m,n]=size(rawdata);

T=rawdata(1,:);

X=zeros(3,n);
X(1,:)=(rawdata(3,:)-rawdata(3,1))*5625000;
X(2,:)=(rawdata(2,:)-rawdata(2,1))*5625000;
X(3,:)=-(rawdata(4,:)-rawdata(4,1));

Xd=zeros(3,n);
Xd(1,:)=rawdata(5,:);
Xd(2,:)=rawdata(6,:);
Xd(3,:)=rawdata(7,:);

Q=tom.Rotation.eulerToQuat((rawdata(8:10,:)-[90;0;0]*ones(1,n))*(pi/180));

dT=gradient(T);

Qd=zeros(4,n);
Qd(1,:)=gradient(Q(1,:))./dT;
Qd(2,:)=gradient(Q(2,:))./dT;
Qd(3,:)=gradient(Q(3,:))./dT;
Qd(4,:)=gradient(Q(4,:))./dT;

end
