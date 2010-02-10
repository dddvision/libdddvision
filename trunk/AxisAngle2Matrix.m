function M=AxisAngle2Matrix(A)
%implementation of Rodrigues' Formula (a form of exponential mapping)
%








K=size(A,2);
M=zeros(3,3,K);
for k=1:K
  er=A(:,k);
  theta=sqrt(er'*er);

  if isnumeric(theta)
    if abs(theta)<1E-16
      M(:,:,k)=eye(3);
      continue;
    end
  else
    if theta==0
      M(:,:,k)=eye(3);
    continue;
    end
  end

  u=er/theta;

  uhat=[[    0,-u(3), u(2)]
        [ u(3),    0,-u(1)]
        [-u(2), u(1),    0]];

  M(:,:,k)=eye(3)+uhat*sin(theta)+uhat*uhat*(1-cos(theta));
end
  
return
