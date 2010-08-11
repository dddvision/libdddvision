function kappa=DetectCorners(gi,gj,halfwin,method)

win=(2*halfwin+1)*[1,1];

%formulate the gradient products
gxx=gi.*gi;
gyy=gj.*gj;
gxy=gi.*gj;

%Perform smoothing or local sum
xx=Smooth2(gxx,win,halfwin/4);
yy=Smooth2(gyy,win,halfwin/4);
xy=Smooth2(gxy,win,halfwin/4);

%calculate corner intensity
kappa=feval(method,xx,yy,xy);

end

