% Radius from center of ellipse to point on the ellipse at an angle from the major axis
% 
% INPUT
% major = largest ellipsoidal radius
% minor = smallest ellipsoidal radius
% lambda = geocentric latitude (1-by-n)
% 








function radius=EllipticalRadius(major,minor,lambda)

A=major*sin(lambda);
B=minor*cos(lambda);

radius=(major*minor)./sqrt(A.*A+B.*B);

return
