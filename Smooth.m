function OUT=Smooth(I,win,sig)
% Performs gaussian smoothing over a window
%
% INPUT ARGUMENTS
% I = intensity image
% win = smoothing window dimensions
% sig = smoothing factor
%
% RETURN VALUE
% OUT = smoothed image
% Public Domain

M=fspecial('gaussian',win,sig);

OUT=filter2(M,I);

return
