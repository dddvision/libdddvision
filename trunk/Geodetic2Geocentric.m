function lambda=Geodetic2Geocentric(gamma)
% gamma = geodetic latitude
% lambda = geocentric latitude
%








if isnumeric(gamma)
  if( (min(gamma)<-pi/2) | (max(gamma)>pi/2) )
    error('Geodetic Earth latitude must fall in the range [-pi/2 pi/2]');
  end

  [re,rp]=WGS84; %loads geographic data
  lambda=atan2((rp/re)^2*sin(gamma),cos(gamma));
  
else
  syms re rp
  lambda=atan((rp/re)^2*sin(gamma)/cos(gamma));
  
end

return
