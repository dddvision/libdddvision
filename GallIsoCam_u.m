function [u1,u2]=GallIsoCam_u(c1,c2,c3,FOV)
%FOV not used
% Copyright 2006 David D. Diel, MIT License

u1=(2/pi)*asin(c3);
u2=(1/pi)*atan2(c2,c1);

end
