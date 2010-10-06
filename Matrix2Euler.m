function Y=Matrix2Euler(R)
  Y=zeros(3,1); 
  if isnumeric(R)
    Y = zeros(3, 1); 
    Y(1) = atan2(R(3, 2), R(3, 3));
    Y(2) = asin(-R(3, 1));
    Y(3) = atan2(R(2, 1), R(1, 1));
  else
    Y = sym(Y);
    R = sym(R); 
    Y(1) = atan(R(3, 2)/R(3, 3));
    Y(2) = asin(-R(3, 1));
    Y(3) = atan(R(2, 1)/R(1, 1));
  end
end
