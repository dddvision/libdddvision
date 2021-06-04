% HistSeg() performs image segmentation based on histogram peaks
%
% input must be an image in range [0,1]
% sig is the desired standard deviation of each labeled output class
% means corresponds to each labeled segment's means
% Copyright 2006 David D. Diel, MIT License
function [S,means]=HistSeg(I,sig)

[m,n]=size(I);

%histogram
cnt=imhist(I);

%convert to probability per bin
p=cnt/(m*n);

%smooth bins assuming user-specified sigma
mask=fspecial('gaussian',[1,round(4*sig+1)],sig);
gp=conv(p,mask);
gp=gp((round(2*sig)+1):(end-round(2*sig)));

%find peaks
peaks=(gp>[gp(2:end);0])&(gp>[0;gp(1:(end-1))]);

%set a mean at each peak
means=find(peaks)./255;

%count number of means
K=length(means);

%classify each pixel according to the closest mean
closest=ones(m,n)*Inf;
S=zeros(m,n);
for k=1:K
	dist=abs(I-means(k));
	winners=find(dist(:)<closest(:));
	S(winners)=k;
	closest(winners)=dist(winners);
end

end
