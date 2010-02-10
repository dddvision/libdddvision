function d=ReadDepth(filename)

raw=double(imread(filename));
red=raw(:,:,1);
far=(red==0);
far=bwmorph(far,'dilate');
d=(65535-red)/1000; %meters
d(far)=NaN;

return