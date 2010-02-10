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
%
%Copyright David D. Diel as of the most recent modification date.
%Permission is hereby granted to the following entities
%for unlimited use and modification of this document:
%  University of Central Florida
%  Massachusetts Institute of Technology
%  Draper Laboratory
%  Scientific Systems Company

M=fspecial('gaussian',win,sig);

OUT=filter2(M,I);

return