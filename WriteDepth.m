function status=WriteDepth(d,fname)
% d = depth map, typically in meters
% fname = the depth file name
% Copyright 2006 David D. Diel, MIT License

status=imwrite(uint16(65535-1000*d),fname,'BitDepth',16,'SignificantBits',16)

return