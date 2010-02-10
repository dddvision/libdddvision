% Calculates the local average using a sliding window
%
% win(1) is the height of the window
% win(2) is the width of the window
%








function I=LocalMean(I,win)
I=colfilt(I,win,'sliding','mean');
return;