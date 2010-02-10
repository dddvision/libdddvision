% INPUT ARGUMENTS:
% Xm = system state before the update
% Pm = state covariance before the update
% C = measurement matrix
% Yres = measurement residual
% Q = covariance of the residual
%
% OUTPUT ARGUMENTS:
% Xp = system state after the update
% Pp = state covariance after the update
% K = Kalman gain
function [Xp,Pp,K]=KalmanUpdate(Xm,Pm,C,Yres,Q)

%gain
K=Pm*C'*inv(C*Pm*C'+Q);

%state update
Xp=Xm+K*Yres;

%covariance update
Pp=(eye(size(K,1))-K*C)*Pm;

end
