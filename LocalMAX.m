% LocalMAX() calculates the local maximum using a sliding window
%
% win(1) is the height of the window
% win(2) is the width of the window
function I=LocalMAX(I,win)
  I=colfilt(I,win,'sliding','max');
end

