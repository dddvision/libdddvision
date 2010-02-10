% Converts ECEF cartesian coordinates to longitude, latitude, altitude
%
% NOTES
% This function assumes the WGS84 model
% Latitude is geodetic (not geocentric)


function lolah = ecef2lolah(ecef)

% input checking
if( size(ecef,1)~=3 )
  error('input must be 3xN');
end

% load WGS84 ellipsoid
[a,b]=WGS84;

x=ecef(1,:);
y=ecef(2,:);
z=ecef(3,:);

[lon,lat,alt]=ecef2lolah_method1(x,y,z,a,b);

RTOD= 180/pi;
lon=RTOD*lon;
lat=RTOD*lat;
lolah=[lon;lat;alt];

return;


% ECEF to LOLAH conversion accurate near the ellipsoid surface.
%
% NOTES
% J. Zhu, "Conversion of Earth-centered Earth-fixed coordinates to geodetic
% coordinates," Aerospace and Electronic Systems, vol. 30, pp.
% 957-961, 1994.
%
function [lon,lat,alt]=ecef2lolah_method1(X,Y,Z,a,b)
f = 1-b/a;
e2 = 2*f-f^2;
ep2 = f*(2-f)/((1-f)^2);
r2 = X.^2+Y.^2;
r = sqrt(r2);
E2 = a^2 - b^2;
F = 54*b^2*Z.^2;
G = r2 + (1-e2)*Z.^2 - e2*E2;
c = (e2*e2*F.*r2)./(G.*G.*G);
s = ( 1 + c + sqrt(c.*c + 2*c) ).^(1/3);
P = F./(3*(s+1./s+1).^2.*G.*G);
Q = sqrt(1+2*e2*e2*P);
ro = -(e2*P.*r)./(1+Q) + sqrt((a*a/2)*(1+1./Q) - ((1-e2)*P.*Z.^2)./(Q.*(1+Q)) - P.*r2/2);
tmp = (r - e2*ro).^2;
U = sqrt( tmp + Z.^2 );
V = sqrt( tmp + (1-e2)*Z.^2 );
zo = (b^2*Z)./(a*V);
alt = U.*( 1 - b^2./(a*V));
lat = atan( (Z + ep2*zo)./r );
lon = atan2(Y,X);
return;
  

% ECEF to LOLAH conversion accurate near the ellipsoid surface.
%
% NOTES
% By Tony Falcone
% function [lon,lat,alt]=ecef2lolah_method2(x,y,z,a,b)
% ab_sqrt = sqrt(a*b);
% rho = b/a;
% rho_inv = a/b;
% k3 = (rho^2 + rho^(-2) + 4);
% r = sqrt(x.*x + y.*y);
% rbsq = (r/ab_sqrt).^2;
% zbsq = (z/ab_sqrt).^2;
% bb = zeros(1,5);
% bb(1) = 1.0;
% bb(2) = 2*(rho + 1/rho);
% N = numel(x);
% lat = zeros(1,N);
% alt = zeros(1,N);
% for n=1:N
%   bb(3) = k3 - (rho_inv*rbsq(n) + rho*zbsq(n));
%   bb(4) = bb(2) - 2.0*(rbsq(n) + zbsq(n));
%   bb(5) = 1.0 - (rho*rbsq(n) + rho_inv*zbsq(n));
%   if bb(5) <= 0.0
%     signum = 1.0;
%   else
%     signum = -1.0;
%   end
%   l = roots(bb);
%   lams = l(imag(l)==0);
%   u = ones(size(lams));
%   t = rbsq(n)*(rho*u./(u + rho*lams)).^2 + zbsq(n)*(rho_inv*u./(u + rho_inv*lams)).^2;
%   hghts = ((ab_sqrt*lams).^2).*t;
%   [hsq,ind] = min(hghts);
%   lam = lams(ind);
%   lat(n) = atan2((rho_inv + lam)*z(n), (rho + lam)*r(n));
%   alt(n) = signum*sqrt(hsq);
% end
% lon = atan2(y,x);
% end


% INACCURATE
% function [lon,lat,alt]=ecef2lolah_method3(X,Y,Z,a,b)
% asq = a^2;
% esq = 1-b^2/asq;
% dsq = asq*(1-esq);
% d   = sqrt(dsq);
% epsq= (asq-dsq)/dsq;
% p   = sqrt(X.^2+Y.^2);
% th  = atan2(a*Z,d*p);
% lon = atan2(Y,X);
% lat = atan2((Z+epsq.*d.*sin(th).^3),(p-esq.*a.*cos(th).^3));
% N   = a./sqrt(1-esq.*sin(lat).^2);
% alt = p./cos(lat)-N;
% 
% % correct for out of bounds latitude
% pp = pi/2;
% ll = logical(lat<-pp);
% lg = logical(lat>pp);
% lat(ll)=lat(ll)+pi;
% lat(lg)=lat(lg)-pi;
% 
% % correct for numerical instability in altitude near poles
% k=abs(X)<1 & abs(Y)<1;
% alt(k) = abs(Z(k))-d;
% return;


% INACCURATE
% function [lon,lat,alt]=ecef2lolah_method4(x,y,z,a,b)
% nudge=1.1;
% SqRatio=(b/a)^2;
% Ecc=sqrt(a^2-b^2)/a;
% rsq = x.*x+y.*y;
% r = sqrt(rsq);
% lon = atan2(y,x);
% t = z./r;
% tsq = t.*t;
% a_rsq = a./r;
% k = (Ecc*Ecc)*a_rsq;
% gamma=zeros(size(t));
% for n=1:numel(t)
%   c=[tsq(n)/SqRatio,-2.0*t(n)/SqRatio,tsq(n)+((1-k(n)*k(n))/SqRatio),-2.0*t(n),1];
%   gamma(n)=e2l_polyNewton(c,nudge*t(n));
% end
% lat = atan(gamma);
% r0 = a./sqrt(1+SqRatio*gamma.*gamma);
% z0 = SqRatio*r0.*gamma;
% alt = sign(rsq/a^2+z.*z/b^2-1).*sqrt((z-z0).*(z-z0)+(r-r0).*(r-r0));
% return;


% This function finds a root of the polynomial
%
%     a(n + 1)*x^n + a(n)*x^(n - 1) + ... + a(2)*x + a(1)
%
% when a is a vector that contains the coefficients of the
% polynomial at a point "near" x0 using Newton's method.
% The result is the location of the root.
%
%     Inputs:        a   -   (Row) Vector of Coefficients
%                    x0  -   Scalar containing starting value
%
%     Output:        x   -   Scalar estimate of root
%
% function x = e2l_polyNewton(a,x0)
% small=1E-9;
% n=size(a,2);
% b=(1:n-1).*a(2:n);
% x=x0;
% y=e2l_polyEval(a,x);
% for k=1:100
%   yprime=e2l_polyEval(b,x);
%   x=x-(y/yprime);
%   y=e2l_polyEval(a,x);
%   if abs(y)<small
%     break;
%   end
% end
% return;


% This function evaluates the polynomial
%
%     a(n + 1)*x(k)^n + a(n)*x(k)^(n - 1) + ... + a(2)*x(k) + a(1)
%
% when a is a vector that contains the coefficients of the
% polynomial and x is a vector that contains the points at which
% evaluation is desired.  The result is a vector the same size as x
% containing the result of evaluation.
%
%     Inputs:        a   -   (Row) Vector of Coefficients
%                    x   -   (Row) Vector of Evaluation Points
%
%     Output:        y   -   (Row) Vector of Output Values
%
% function y = e2l_polyEval(a,x)
% n=size(a,2);
% y=a(n);
% for j=n-1:-1:1
%   y=y*x+a(j);
% end
% end

% Ref: http://www.microem.ru/pages/u_blox/tech/dataconvert/GPS.G1-X-00006.pdf
%      Retrieved 11/30/2009
% function [lon,lat,alt] = ecef2lolah_method6(x,y,z,a,b)
%   e = sqrt((a.^2-b.^2)./a.^2);
%   e_prime = sqrt((a.^2-b.^2)./b.^2);
% 
%   p = sqrt(x.^2+y.^2);
% 
%   theta = atan((z*a)./(p*b));
% 
%   lon = atan(y./x);
%   lat = atan((z+e_prime^2*b*(sin(theta).^3))./ ...
%              (p-e^2*a*(cos(theta).^3)));
%   % Compute prime vertical of curvature (meters)
%   N = a./sqrt(1-e.^2*(sin(lat).^2));
% 
%   alt = p./cos(lat) - N;
% end
