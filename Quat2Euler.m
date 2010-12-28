function Y=Quat2Euler(Q)








Q=QuatNorm(Q);

q1=Q(1,:);
q2=Q(2,:);
q3=Q(3,:);
q4=Q(4,:);

q11=q1.*q1;
q22=q2.*q2;
q33=q3.*q3;
q44=q4.*q4;

q12=q1.*q2;
q23=q2.*q3;
q34=q3.*q4;
q14=q1.*q4;
q13=q1.*q3;
q24=q2.*q4;

if isnumeric(Q)
  Y(1,:)=atan2(2*(q34+q12),q11-q22-q33+q44);
  Y(2,:)=real(asin(-2*(q24-q13)));
  Y(3,:)=atan2(2*(q23+q14),q11+q22-q33-q44);
else
  Y(1,:)=atan((2*(q34+q12))./(q11-q22-q33+q44));
  Y(2,:)=asin(-2*(q24-q13));
  Y(3,:)=atan((2*(q23+q14))./(q11+q22-q33-q44));
end
  
return