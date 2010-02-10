function I=Normalize(I)
% Normalize() forces an image to span [0,1]

I=double(I);
a=min(I(:));
I=I-a;
b=max(I(:));
I=I/b;
end
