function OUT=Smooth2(I,win,sig)
% OUT=Smooth2(I,win,sig) performs gaussian smoothing over a window
%
% I=intensity image
% sig=smoothing factor
% OUT=output image
%








M=fspecial('gaussian',win,sig);

OUT=filter2(M,I);

return
