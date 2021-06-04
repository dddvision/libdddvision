% LocalAverage() computes the local average over a window for each pixel
%
% win=[height width];
% Public Domain
function I=LocalAverage(I,win)
M=fspecial('average',win);
I=filter2(M,I);
end
