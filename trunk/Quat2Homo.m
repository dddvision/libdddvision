% Converts a quaternion into homogenous form
%
% USAGE
% Qb=Quat2Homo(Qa)*Qab;
%
% NOTES
% Premultiplication corresponds to rotation of an inner gimbaled axis


function h=Quat2Homo(q)

if length(q)~=4
  warning('input should have length 4');
end

q1=q(1);
q2=q(2);
q3=q(3);
q4=q(4);

h=[[q1,-q2,-q3,-q4]
   [q2, q1,-q4, q3]
   [q3, q4, q1,-q2]
   [q4,-q3, q2, q1]];

return
