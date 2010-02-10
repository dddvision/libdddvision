function HF=hf_read(fname)

raw=imread(filename)
HF=double(raw(:,:,1))/65535;

return