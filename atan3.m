% Similar to atan2, but also places the result as close to the center of 
% the provided angular bounds as possible through rotations of +/- 2*pi
function a=atan3(num,den,amin,amax)
acen=(amin+amax)/2;
a=atan2(num,den);
k=(a>(acen+pi));
a(k)=a(k)-2*pi;
k=(a<(acen-pi));
a(k)=a(k)+2*pi;
end

