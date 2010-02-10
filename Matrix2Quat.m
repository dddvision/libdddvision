function Q=Matrix2Quat(M)
%this transformation has no nice direct method
%the best method is to convert to Euler angles first, then to quaternions
%








Y=Matrix2Euler(M);
Q=Euler2Quat(Y);

return
