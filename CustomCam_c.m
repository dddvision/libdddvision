function [c1,c2,c3]=CustomCam_c(m,n,fname)
% Copyright 2006 David D. Diel, MIT License

fid = fopen(fname,'r');
txt = char(fread(fid,inf,'char')');
fclose(fid);

ind = findstr(txt,'CAMERA_TYPE');
type = sscanf(txt,'CAMERA_TYPE=%s');


switch type
  case 'parabolic'
    % Omnicam ray vector definition by Mike Bosse
    % Edited by David Diel
    ind = findstr(txt,'Quat');
    quat = sscanf(txt(ind:end),'Quat=[4x1]{%f,%f,%f,%f}');
    quat=quat/norm(quat);
    
    ind = findstr(txt,'Trans');
    trans = sscanf(txt(ind:end),'Trans=[3x1]{%f,%f,%f}');
    
    ind = findstr(txt,'Mirror');
    data = sscanf(txt(ind:end),'Mirror=[%dx1]{%f,%f,%f,%f,%f');
    mirror = data(2:end);
    
    ind = findstr(txt,'Intrinsics');
    data = sscanf(txt(ind:end),'Intrinsics=[5x1]{%f,%f,%f,%f,%f');
    
    %also offset for 1based indexing
    A = [data(1) data(3) data(4)+1; 0 data(2) data(5)+1; 0 0 1];
    
    %ind = findstr(txt,'Width');
    %sz = sscanf(txt(ind:end),'Width=%f,Height=%f')';
    sz=[n,m];
    
    cam.q = quat;
    cam.Rctw = tom.Rotation.quatToMatrix(quat);
    cam.trans = trans;
    cam.size = sz;
    cam.A = A; 
    
    cam.mirrorR = mirror(1);
    cam.mirrorX = mirror(2);
    cam.mirrorY = mirror(3);
    cam.mirrorFOV = mirror(4);
    
    if length(mirror)>=5
      cam.mirrorF = mirror(5);
    else
      cam.mirrorF = 0;
    end
    
    cam.type = type;
    
    %done reading the file, now creating the camera rays
    %function rays = point2ray(points, A, k, center, kappa)
    %like Ainv
    
    %not sure if this is ever used
    % if (nargin>4)
    %    points = undistort_radial(points, A, kappa);
    % end
    
    A = cam.A;
    k = cam.mirrorR;
    center = [cam.mirrorX cam.mirrorY];
    
    [y,x]=meshgrid(1:sz(1),1:sz(2));
    points=[y(:)';x(:)'];
    
    rays = inv(A)*[points; ones(1,prod(sz))];
    
    rays(1,:) = rays(1,:)-center(1);
    rays(2,:) = rays(2,:)-center(2);
    rays(3,:) = (k^2-rays(1,:).^2-rays(2,:).^2)./(2*k);
    
    c1=reshape(rays(3,:),[sz(2),sz(1)]);
    c2=reshape(rays(1,:),[sz(2),sz(1)]);
    c3=reshape(rays(2,:),[sz(2),sz(1)]);
    
    den=sqrt(c1.*c1+c2.*c2+c3.*c3);
    
    c1=c1./den;
    c2=c2./den;
    c3=c3./den;
    
    bad=c1<cos(cam.mirrorFOV*pi/180);
    c1(bad)=NaN;
    c2(bad)=NaN;
    c3(bad)=NaN;
    
    
  case 'DivisionCam'
    ind = findstr(txt,'HEIGHT');
    HEIGHT = sscanf(txt(ind:end),'HEIGHT=%d');
    
    ind = findstr(txt,'WIDTH');
    WIDTH = sscanf(txt(ind:end),'WIDTH=%d');
    
    if (m~=HEIGHT)|(n~=WIDTH)
      warning('calibration data may not correspond to the requested image size');
    end
    
    ind = findstr(txt,'THETA_MAX');
    thmax = sscanf(txt(ind:end),'THETA_MAX=%f');
    
    ind = findstr(txt,'ic');
    ic = sscanf(txt(ind:end),'ic=%f');
    
    ind = findstr(txt,'jc');
    jc = sscanf(txt(ind:end),'jc=%f');
    
    ind = findstr(txt,'ab');
    ab = sscanf(txt(ind:end),'ab=%f,%f,%f,%f');
    a1=ab(1);
    a2=ab(2);
    b1=ab(3);
    b2=ab(4);
    
    %setup shifted array coordinates
    [j,i]=meshgrid(1:n,1:m);
    j=j-jc;
    i=i-ic;
    r=sqrt(i.*i+j.*j);
    
    %exclude pixels outside of the image circle
    rmax=(ab(1)*thmax+ab(2)*thmax^2)./(1+ab(3)*thmax+ab(4)*thmax^2);
    r(r>rmax)=NaN;
    cen=find(r<eps);
    
    r2=r.*r;
    th=(sqrt(a1^2-2*a1*b1*r+(4*a2+(b1^2-4*b2)*r).*r)-a1+b1*r)./(2*(a2-b2*r));
    c1=cos(th);
    r(cen)=1;
    c2=sin(th).*j./r;
    c3=sin(th).*i./r;
    
  otherwise
    error('unrecognized camera type');
end

end
