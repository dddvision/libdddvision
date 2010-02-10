function v=Quat2AxisAngle(q)








q=QuatNorm(q);

q1=q(1,:);
q2=q(2,:);
q3=q(3,:);
q4=q(4,:);

theta=2*acos(q1);
n=sqrt(q2.*q2+q3.*q3+q4.*q4);

if isnumeric(q)
  zt=[zeros(size(theta));theta];
  zt=unwrap(zt);
  theta=zt(2,:);
  ep=1E-12;
  n(n<ep)=ep;
end

a=q2./n;
b=q3./n;
c=q4./n;

v1=theta.*a;
v2=theta.*b;
v3=theta.*c;

v=[v1;v2;v3];

return
