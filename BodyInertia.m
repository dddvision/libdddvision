function [dtheta_body,fav_body]=BodyInertia(Q,Qdav,Qddav,GeoOmega,GeoAccel,g,T)
% Copyright 2006 David D. Diel, MIT License

%note: Q contains one time step before Qdav and Qddav begin
QR=Q(1:4,:);
QRinv=tom.Rotation.quatInv(Q(1:4,:));
QTdd=Qddav(5:7,:);
DT=ones(3,1)*diff(T);

N=size(Q,2)-1;
fav_body=zeros(3,N);
dtheta_body=zeros(3,N);

f=QTdd+GeoAccel-g;
GeoQuat=tom.Rotation.axisToQuat(GeoOmega.*DT);
for i=1:N
  %reference orientation
  Rwb=tom.Rotation.quatToMatrix(QRinv(:,i));
  
  %delta angle
  Qa=QR(:,i);
  Qb=tom.Rotation.quatToHomo(GeoQuat(:,i))*QR(:,i+1);
  dQ=tom.Rotation.quatToHomo(tom.Rotation.quatInv(Qa))*Qb;
  dtheta_body(:,i)=tom.Rotation.quatToEuler(dQ);
  
  %specific force
  fav_body(:,i)=Rwb*f(:,i);
end

%IMU definition is like omega
dtheta_body=dtheta_body./DT;

end
