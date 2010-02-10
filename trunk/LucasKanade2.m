








function [u,v]=LucasKanade2(fx,fy,ft,win)
%finds dense velocity image

xx=colfilt(fx.*fx,win,'sliding',@sum);
yy=colfilt(fy.*fy,win,'sliding',@sum);
xy=colfilt(fx.*fy,win,'sliding',@sum);
xt=colfilt(fx.*ft,win,'sliding',@sum);
yt=colfilt(fy.*ft,win,'sliding',@sum);

den=xx.*yy-xy.*xy;

small=0.000000001;
den(den==0)=small;
bad=abs(den)<small;
den(bad)=small*sign(den(bad));

u=(xy.*yt-xt.*yy)./den;
v=(xt.*xy-xx.*yt)./den;

shift=[
1  1  0;
1  1  0;
0  0  0]/4;

u=filter2(shift,u);
v=filter2(shift,v);

return
