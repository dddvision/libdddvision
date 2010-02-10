% LocalSUM() calculates the local SUM using a sliding window
%
% win(1) is the height of the window
% win(2) is the width of the window
function I=LocalSUM(I,win)
M=ones(win(1),win(2));
I=filter2(M,I);
end
