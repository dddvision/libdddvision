% Expand2() computes smaller layer of a conservative pyramid
%








function largeIm=Expand2(im)

[m,n]=size(im);
largeIm=zeros(2*m,2*n);

im=im/4;

largeIm(1:2:end,1:2:end)=im;
largeIm(2:2:end,1:2:end)=im;
largeIm(1:2:end,2:2:end)=im;
largeIm(2:2:end,2:2:end)=im;
return