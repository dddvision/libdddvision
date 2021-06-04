function []=hf_write(HF,fname)
% Copyright 2006 David D. Diel, MIT License

imwrite(uint16(HF*65535),fname,'BitDepth',16,'SignificantBits',16);

return