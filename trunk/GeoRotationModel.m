function [OmegaNED,XddNED]=GeoRotationModel(X_rel,Xdav_rel,gamma)
% Calculates the acceleration and rotation rate effects felt in a
% non-inertial North-East-Down Earth-fixed frame
%
% INPUT:
% X_rel = position relative to the NED frame origin (3-by-n)
% Xdav_rel = average velocity relative to the NED frame origin (3-by-n)
% gamma = geodetic latitude of the NED frame origin
%
% OUTPUT:
% OmegaNED = rotation rate effect in the NED frame (3-by-n)
% XddNED = acceleration effect in the NED frame (3-by-n)
%








[m,na]=size(X_rel);
if m~=3
  error('Relative position argument must be 3-by-(n+1)');
end

[m,nb]=size(Xdav_rel);
if m~=3
  error('Relative velocity argument must be 3-by-n');
end

if (na~=nb)
  error('The number of position samples must equal the number of velocity samples');
end
N=na;

%constants
[re,rp,omega]=WGS84;
lambda=Geodetic2Geocentric(gamma);
rs=EllipticalRadius(re,rp,lambda);
sgam=sin(gamma);
cgam=cos(gamma);
omega2=omega^2;

%seperating the data
x1=X_rel(1,:);
x2=X_rel(2,:);
x3=X_rel(3,:);

xd1=Xdav_rel(1,:);
xd2=Xdav_rel(2,:);
xd3=Xdav_rel(3,:);

%velocity equation
%Nd = xd1 + omega*sgam*x2;
%Ed = xd2 - omega*sgam*x1 - omega*cgam*x3 + omega*r*cgam;
%Dd = xd3 + omega*cgam*x2;
%XdNED=[Nd;Ed;Dd];

%rotation rate equation
ON=omega*cgam*ones(1,N);
OE=zeros(1,N);
OD=-omega*sgam*ones(1,N);
OmegaNED=[ON;OE;OD];

%acceleration equation
Ndd = 2*omega*sgam*xd2                     - omega2*sgam^2*x1 - omega2*sgam*cgam*x3 + omega2*rs*cgam*sgam;
Edd = -2*omega*sgam*xd1 - 2*omega*cgam*xd3 - omega2*x2;
Ddd = 2*omega*cgam*xd2                     - omega2*sgam*cgam*x1 - omega2*cgam^2*x3 + omega2*rs*cgam^2;
XddNED=[Ndd;Edd;Ddd];

return
