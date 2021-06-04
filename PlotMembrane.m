function handle=PlotMembrane(q,cd,RGB,al)
% Copyright 2006 David D. Diel, MIT License

x1=cd(:,:,1);
x2=cd(:,:,2);
x3=cd(:,:,3);

R=tom.Rotation.quatToMatrix(q(1:4));

xp1=R(1,1)*x1+R(1,2)*x2+R(1,3)*x3+q(5);
xp2=R(2,1)*x1+R(2,2)*x2+R(2,3)*x3+q(6);
xp3=R(3,1)*x1+R(3,2)*x2+R(3,3)*x3+q(7);

handle=surface(xp1,xp2,xp3,RGB,...
  'FaceColor','texturemap','EdgeColor','none','CDataMapping','direct');

if nargin>3
  alpha(handle,al);
end

end
