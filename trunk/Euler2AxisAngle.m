function V=Euler2AxisAngle(Y)








Q=Euler2Quat(Y);
V=Quat2AxisAngle(Q);

return
