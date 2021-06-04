% Performs gaussian smoothing over a window
%
% I=intensity image
% sig=smoothing factor
% OUT=output image
% Public Domain

function OUT=Smooth2(I,win,sig)
  M=fspecial('gaussian',win,sig);
  OUT=filter2(M,I);
end

