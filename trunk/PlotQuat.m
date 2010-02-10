function []=PlotQuat(q,qdot)
% Plots a graphical representation of a body orientation and rate.
%
% q = quaternion <scalar,vector> representation of the body orientation (4-by-1)
% qdot = quaternion <scalar,vector> representation of the body rotation rate (4-by-1)
%
% AUTHOR: David D. Diel
% DATE: July 2003


%points to define the "airplane"
p(:,1)=[4;0;0]; %axis 1
p(:,2)=[0;1;0]; %axis 2.a
p(:,3)=[0;-1;0]; %axis 2.b
p(:,4)=[0;0;-0.5]; %axis 3

%rotate the points
M=Quat2Matrix(q);
pp=M*p;

X=pp(1,:);
Y=pp(2,:);
Z=pp(3,:);

Tri=[[1,2,3]
     [2,3,4]
     [3,4,1]
     [4,1,2]];

%plot orientations and rates
trisurf(Tri,X,-Y,-Z,[0,1,0.5,0.5]);
hold on
plot3(0,0,0,'r.')

if nargin==2 %rates
  vc=2.5*[-1;1;1]; %center of little coordinate system

  J=2*[[-q(2), q(1),-q(4), q(3)]
       [-q(3), q(4), q(1),-q(2)]
       [-q(4),-q(3), q(2), q(1)]]; %jacobian between quaternion rate and body axis rates
  
  vdot=J*qdot;
  
  plot3(vc(1)+[0;vdot(1)],vc(2)-[0;vdot(2)],vc(3)-[0;vdot(3)],'r.-');
  
  %show a tiny axis system
  plot3(vc(1)+[0;1],vc(2)-[0;0],vc(3)-[0;0],'c-');
  plot3(vc(1)+[0;0],vc(2)-[0;1],vc(3)-[0;0],'c-');
  plot3(vc(1)+[0;0],vc(2)-[0;0],vc(3)-[0;1],'c-');
end

hold off
axis square
axis([-5,5,-5,5,-5,5])
set(gca,'XTickLabel',[])
set(gca,'YTickLabel',[])
set(gca,'ZTickLabel',[])

xlabel('axis 1');
ylabel('axis 2');
zlabel('axis 3');

set(gcf,'Color',[0,0,0])
set(gca,'Color',[0.1,0.1,0.1])

return