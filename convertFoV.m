% Convert vertical or horizontal field of view to the other.
%
% @param[in] fieldOfViewR     field of view in radians
% @param[in] pixParallel      number of pixels in the direction of the given vield of view
% @param[in] pixPerpendicular number of pixels in the direction perpendicular to the given field of view
function fieldOfViewR = convertFoV(fieldOfViewR, pixParallel, pixPerpendicular)
fieldOfViewR = 2.0*atan2(tan(fieldOfViewR/2.0)*pixPerpendicular, pixParallel);
end
