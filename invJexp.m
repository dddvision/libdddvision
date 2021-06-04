% Jacobian mapping of quaternion rate to axis-angle rate
%
% q = orientation in quaternion form (4-by-1)
% J = Jacobian (3-by-4)
% opt = (obsolete) interpret output argument as (1) axis-angle or (2) axis-halfangle
% Copyright 2006 David D. Diel, MIT License
function J = invJexp(q, opt)
  q1 = q(1);
  q2 = q(2);
  q3 = q(3);
  q4 = q(4);

  s = sqrt(1-q1^2);
  qvm = sqrt(q2^2+q3^2+q4^2);
  qvm3 = qvm^3;
  ac = acos(q1);

  qvm(qvm<eps) = eps;
  qvm3(qvm3<eps) = eps;
  s(s<eps) = eps;

  J = [[-1/s*q2/qvm, ac/qvm-ac*q2^2/qvm3, -ac*q2/qvm3*q3     , -ac*q2/qvm3*q4     ]
       [-1/s*q3/qvm, -ac*q2/qvm3*q3     , ac/qvm-ac*q3^2/qvm3, -ac*q3/qvm3*q4     ]
       [-1/s*q4/qvm, -ac*q2/qvm3*q4     , -ac*q3/qvm3*q4     , ac/qvm-ac*q4^2/qvm3]];

  if(opt==1)
    J=J*2;
  end
end
