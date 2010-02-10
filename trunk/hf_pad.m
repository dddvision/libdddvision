function P=hf_pad(H)

%normalizing
H=double(H);
H=normalize(H);

%checking values in center of height field
[m,n]=size(H);
mc=floor(m/2+0.5);
nc=floor(n/2+0.5);
hc=H(mc,nc);
sc=1/(2*max(1-hc,hc-1));

if (hc<0.1)|(hc>0.9)
	error('this height field cannot be padded');
end

%scaling
[y,x]=meshgrid((0:n-1)/(n-1),(0:m-1)/(m-1));
SC=1-sc*sin(pi*sqrt(((x-0.5).^2).*((y-0.5).^2)));
H=SC.*H;

%boundary smoothing
k=0.1;
pad=(1-exp(-x/k)).*(1-exp(-y/k)).*(1-exp((x-1)/k)).*(1-exp((y-1)/k));
pad=pad/pad(mc,nc);
P=H.*pad;

return