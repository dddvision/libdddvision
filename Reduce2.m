function smallIm=Reduce2(im)
% Recuce2() computes smaller layer of a conservative pyramid

mask = [1,1;1,1];
Result = conv2(im, mask);
smallIm = Result(1:2:(end-1),1:2:(end-1));
return