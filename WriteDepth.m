function status=WriteDepth(d,fname)
% d = depth map, typically in meters
% fname = the depth file name

status=imwrite(uint16(65535-1000*d),fname,'BitDepth',16,'SignificantBits',16)

return