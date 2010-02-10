% Converts from LOLAH to ECEF
%
% INPUT
% lolah = [ Longitude (radians) ; Latitude (radians) ; Height (meters) ], 3-by-N
%
% OUTPUT
% ecef = Earth Centered Earth Fixed coordinates
%        UEN orientation at the meridian/equator origin (meters), 3-by-N
% 
% Ref: http://www.microem.ru/pages/u_blox/tech/dataconvert/GPS.G1-X-00006.pdf
%      Retrieved 11/30/2009
function ecef=lolah2ecef(lolah)

% input checking
if( size(lolah,1)~=3 )
  error('input must be 3xN');
end

  lon = lolah(1,:);
  lat = lolah(2,:);
  alt = lolah(3,:);
  a = 6378137;
  finv = 298.257223563;
  b = a-a/finv;
  a2 = a.*a;
  b2 = b.*b;
  e = sqrt((a2-b2)./a2);
  slat = sin(lat);
  clat = cos(lat);
  N = a./sqrt(1-(e*e)*(slat.*slat));
  ecef = [(alt+N).*clat.*cos(lon);
          (alt+N).*clat.*sin(lon);
          ((b2./a2)*N+alt).*slat];
end

% METHOD 2
% lon=lolah(1,:);
% gamma=lolah(2,:);
% h=lolah(3,:);
% re = 6378137.0;
% finv = 298.257223563;
% rp = re-re/finv;
% clon=cos(lon);
% slon=sin(lon);
% cgamma=cos(gamma);
% sgamma=sin(gamma);
% ratio=rp/re;
% lambda=atan2(ratio*ratio*sgamma,cgamma);
% A=re*sin(lambda);
% B=rp*cos(lambda);
% r=(re*rp)./sqrt(A.*A+B.*B);
% clambda=cos(lambda);
% slambda=sin(lambda);
% surface=[r.*clon.*clambda;r.*slon.*clambda;r.*slambda];
% above=[h.*clon.*cgamma;h.*slon.*cgamma;h.*sgamma];
% ecef=surface+above;

% METHOD 3
% SqRatio=(rp/re)^2;
% tlat = tan(gamma);
% r0 = re./sqrt(1+SqRatio*tlat.*tlat);
% z0 = SqRatio*r0.*tlat;
% r = r0+h.*cgamma;
% ecef = [r.*clon;r.*slon;z0+h.*sgamma];
