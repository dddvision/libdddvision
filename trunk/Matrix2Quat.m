% Convert matrix rotation representation to quaternion
%
% NOTES
% This transformation has no direct method, so convert to Euler angles, then to quaternions
function Q = Matrix2Quat(M)

Y = Matrix2Euler(M);
Q = Euler2Quat(Y);

end
