% WGS84 Data
% Minor radius derived from major radius and ellipsoidal flattening
% References:
%   WGS84 Implementation Manual, v.2.4, 1998
%   WGS84: It's definition and relationship to Local Geodetic Systems. NIMA Technical Report, 3rd ed. 2000.
function [EarthMajorRadius,EarthMinorRadius,EarthRotationRate,...
          EquatorialGravity,PolarGravity,GM,C20]=WGS84()
%raw data
EarthMajorRadius = 6378137.0; %meters
EarthRotationRate = 7.292115E-5; %rad/sec
InverseFlattening = 298.257223563; %unitless
GM = 3.986005E14; % meters^3/sec^2
%Flattening = 1/298.257223563; %unitless
%SurfacePotential = 62636851.7146; %meters^2/sec^2

%derived data
C20 = -4.84166E-4; %unitless (combined sources)
EarthMinorRadius = EarthMajorRadius-EarthMajorRadius/InverseFlattening; %meters (Implementation Manual)
PolarGravity = -9.8321849378; %meters/sec^2 (NIMA)
EquatorialGravity = -9.7803253359-(EarthRotationRate*EarthRotationRate*1000000)*(EarthMajorRadius/1000000); %meters/sec^2 (combined sources)
%EquatorialGravity = -9.78049-(EarthRotationRate*EarthRotationRate*1000000)*(EarthMajorRadius/1000000); %meters/sec^2 (Jim Donna)

%VALUES FROM JIM DONNA
%PolarGravity=-9.8322131433;
%EquatorialGravity=-9.8144057073;
end

