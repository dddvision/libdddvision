function handle=PlotBody(x,SCALE)
% Copyright 2006 David D. Diel, MIT License

p(:,1)=[4;0;0]; %axis 1
p(:,2)=[0;1;0]; %axis 2.a
p(:,3)=[0;-1;0]; %axis 2.b
p(:,4)=[0;0;-0.5]; %axis 3

R=tom.Rotation.quatToMatrix(x(1:4));
pp=SCALE*R*p+x(5:7)*ones(1,4);

Tri=[[1,2,3]
     [2,3,4]
     [3,4,1]
     [4,1,2]];

handle=trisurf(Tri,pp(1,:),pp(2,:),pp(3,:),[0,1,0.5,0.5]);

end
