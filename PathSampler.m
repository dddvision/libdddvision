function [Q,Qd,Qdd]=PathSampler(Qt,ti)
% Copyright 2006 David D. Diel, MIT License

m=size(Qt,1);
n=size(ti,2);

%position
Q=zeros(m,n);
for i=1:m
  Q(i,:)=feval(vectorize(inline(char(Qt(i)))),ti);
end

%velocity
if (nargout>=2)
  Qtd=diff(Qt,'t');
  Qd=zeros(m,n);
  for i=1:m
    Qd(i,:)=feval(vectorize(inline(char(Qtd(i)))),ti);
  end
end

%acceleration
if (nargout==3)
  Qtdd=diff(Qtd,'t');
  Qdd=zeros(m,n);
  for i=1:m
    Qdd(i,:)=feval(vectorize(inline(char(Qtdd(i)))),ti);
  end
end

return
