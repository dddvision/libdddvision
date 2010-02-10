function gNED=GravityModel(NED,gamma,model)
% 2-D ellipsoidal 1/r falloff gravity potential model
% 
% NED = Earth surface relative coordinates in North-East-Down frame 
% gamma = geodetic latitude of NED frame origin
% model = gravity model ('Harmonic2','NearEarth')
% gNED = gradient of the potential field viewed in NED frame
%








N=NED(1,:);
E=NED(2,:);
D=NED(3,:);

%geological constants
[re,rp,omega,ge,gp,GM,C20]=WGS84;
lambda=Geodetic2Geocentric(gamma);
r=EllipticalRadius(re,rp,lambda);

%precalculations
sgam=sin(gamma);
cgam=cos(gamma);
slam=sin(lambda);
clam=cos(lambda);

%position relative to the 3-D ellipsoid in Earth-centered frame
X = r*clam - sgam*N - cgam*D;
Y =                 E;
Z = r*slam + cgam*N - sgam*D;

%relative longitude
theta=atan2(Y,X);
sth=sin(theta);
cth=cos(theta);

switch model

case 'Harmonic2'
  R2 = X.*X+Y.*Y+Z.*Z;
  XY = sqrt(X.*X+Y.*Y);
  
  %gradient of the potential around the 2-D ellipse model   
  GMR2  = (GM./R2);
  re2R2 = ((re*re)./R2);
  
  gR = -GMR2.*(1+(9/2*sqrt(5)*C20)*re2R2.*(Z.*Z./R2-1/3));
  gT = (3*sqrt(5)*C20)*GMR2.*re2R2.*(XY.*Z./R2);

  gZ  = gR*slam+gT*clam;
  gXY = gR*clam-gT*slam;

  gX = gXY.*cth;
  gY = gXY.*sth;

  %gravity viewed in NED frame
  gN = -sgam*gX + cgam*gZ;
  gE =         gY;
  gD = -cgam*gX - sgam*gZ;

  gNED = [gN;gE;gD];

case 'NearEarth'
  XY = sqrt(X.*X+Y.*Y);
  R = sqrt(X.*X+Y.*Y+Z.*Z);
    
  %coefficients
  g0 = 9.78039; %meter/sec^2 adjusted value replaces 9.78049
  g1 = 1.33e-8; %1/sec^2
  g2 = 5.2884e-3; % dimensionless
  g3 = -5.9e-6; % dimensionless
  g4 = -3.0877e-6; % 1/sec^2
  g5 = 4.5e-8; % 1/sec^2
  g6 = 7.2e-13; % 1/(meter*sec^2)  
   
  %instantaneous latitude
  lam = atan2(Z,XY);
  gam = Geocentric2Geodetic(lam);
  
  %instantaneous height
  h = R - EllipticalRadius(re,rp,lam);
  
  %precalculations
  clat = cos(gam);
  slat = sin(gam);
  slat2 = slat.*slat;
  s2lat = sin(2*gam);
  s2lat2 = s2lat.*s2lat;
  
  %gravity model
  gNp = g1*h.*s2lat;
  gDp = g0*(1.0 + g2*slat2 + g3*s2lat2) + (g4 + g5*slat2).*h + g6*h.*h;
  
  gZ  =  clat.*gNp-slat.*gDp;
  gXY = -slat.*gNp-clat.*gDp - (omega*omega*100000)*(XY./100000);

  gX = gXY.*cth;
  gY = gXY.*sth;

  %gravity viewed in NED frame
  gN = -slat.*gX + clat.*gZ;
  gE =         gY;
  gD = -clat.*gX - slat.*gZ;

  gNED = [gN;gE;gD];
  
% case 'EllipticPotential'
%   %gradient of the potential around the 2-D ellipse model
%   ke = -ge*re*re;
%   kp = -gp*rp*rp;
%   
%   XY  = sqrt(X.*X+Y.*Y);
%   gZ  = -Z.*( XY.*XY*ke^(-2)*kp^(4/3) + Z.*Z*kp^(-2/3) ).^(-3/2);
%   gXY = -XY.*( XY.*XY*ke^(-2/3) + Z.*Z*kp^(-2)*ke^(4/3) ).^(-3/2);
% 
%   gX  = gXY.*cth;
%   gY  = gXY.*sth;
% 
%   %gravity viewed in NED frame
%   gN = -sgam*gX + cgam*gZ;
%   gE =         gY;
%   gD = -cgam*gX - sgam*gZ;
% 
%   gNED = [gN;gE;gD];

end

return
