function [I,RGB]=ReadColor(filename)
% Copyright 2006 David D. Diel, MIT License

RGB=imread(filename);

switch size(RGB,3)
  case 1
    I=double(RGB)/255;
  case 3
    I=double(rgb2gray(RGB))/255;
  otherwise
    error('imread() returned an unusual image format');
end

return