function gamma=Geocentric2Geodetic(lambda)
% lambda = geocentric latitude
% gamma = geodetic latitude
[re,rp]=WGS84; %loads geographic data

if( sum((lambda<-pi/2)|(lambda>pi/2)) )
  warning('Geocentric Earth Latitude must fall in the range [-pi/2 pi/2]');
end

A=re/rp;
gamma=atan2((A*A)*sin(lambda),cos(lambda));

end

