function R=Roberts(I)
% Public Domain

amask=[
0  0  0;
0 -1  0;
0  0  1];

bmask=[
0  0  0;
0  0  1;
0 -1  0];

Ra=filter2(amask,I);
Rb=filter2(bmask,I);

R=sqrt(Ra.*Ra+Rb.*Rb);

return