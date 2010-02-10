function [dtheta_body,fav_body]=BodyInertia(Q,Qdav,Qddav,GeoOmega,GeoAccel,g,T)








%note: Q contains one time step before Qdav and Qddav begin
QR=Q(1:4,:);
QRinv=QuatConj(Q(1:4,:));
QTdd=Qddav(5:7,:);
DT=ones(3,1)*diff(T);

N=size(Q,2)-1;
fav_body=zeros(3,N);
dtheta_body=zeros(3,N);

f=QTdd+GeoAccel-g;
GeoQuat=AxisAngle2Quat(GeoOmega.*DT);
for i=1:N
  %reference orientation
  Rwb=Quat2Matrix(QRinv(:,i));
  
  %delta angle
  Qa=QR(:,i);
  Qb=Quat2Homo(GeoQuat(:,i))*QR(:,i+1);
  dQ=Quat2Homo(QuatConj(Qa))*Qb;
  dtheta_body(:,i)=Quat2Euler(dQ);
  
  %specific force
  fav_body(:,i)=Rwb*f(:,i);
end

%IMU definition is like omega
dtheta_body=dtheta_body./DT;

return
