function []=hf_write(HF,fname)

imwrite(uint16(HF*65535),fname,'BitDepth',16,'SignificantBits',16);

return