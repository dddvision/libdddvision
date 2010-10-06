% Converts a quaternion into homogenous form
%
% USAGE
% Qac=Quat2Homo(Qab)*Qbc;
%
% NOTES
% Premultiplication corresponds to rotation of an inner gimbaled axis
function h=Quat2Homo(q)
  if(numel(q)~=4)
    error('Input must have exactly 4 elements');
  end
  q1 = q(1);
  q2 = q(2);
  q3 = q(3);
  q4 = q(4);
  h = [[q1, -q2, -q3, -q4]
       [q2,  q1, -q4,  q3]
       [q3,  q4,  q1, -q2]
       [q4, -q3,  q2,  q1]];
end
