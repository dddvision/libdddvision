function Y=AxisAngle2Euler(V)
M=AxisAngle2Matrix(V);
Y=Matrix2Euler(M);
end

