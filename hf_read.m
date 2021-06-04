function HF=hf_read(fname)
% Copyright 2006 David D. Diel, MIT License

raw=imread(filename)
HF=double(raw(:,:,1))/65535;

return