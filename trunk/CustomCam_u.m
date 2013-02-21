function [u1,u2]=CustomCam_u(c1,c2,c3,fname)

fid = fopen(fname,'r');
txt = char(fread(fid,inf,'char')');
fclose(fid);

ind = findstr(txt,'CAMERA_TYPE');
type = sscanf(txt,'CAMERA_TYPE=%s');


switch type
  case 'OmniCam'
    % Omnicam image projection by Mike Bosse
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
    sz=fliplr(size(c1));
    
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
    
    %done reading the file, now process the rays
    %function [x,y] = omni_ray2point(rays,A,k,center,gamma)
    
    % we know is that cam.sz contains width and height
    rays=[c2(:)';c3(:)';c1(:)'];
    
    A = cam.A;
    k = cam.mirrorR;
    center = [cam.mirrorX cam.mirrorY];
    
    if 0
      r2 = sum(rays(1:2,:).^2) + eps;
      %r2(find(r2==0))=1; %to prevent divide by zero errors
      
      w = k* (sqrt(r2+rays(3,:).^2)-rays(3,:))./r2;
    else
      % this is much simpler!
      w = k./ (sqrt(sum(rays(1:3,:).^2)) + rays(3,:));
    end
    points = A*[rays(1,:).*w + center(1);
                rays(2,:).*w + center(2);
                ones(size(w))];
    
    % not sure if this is ever used
    % if (nargin>4)
    %    points = undistort_radial(points, A, gamma);
    % end
    
    j=reshape(points(1,:),[sz(2),sz(1)]);
    i=reshape(points(2,:),[sz(2),sz(1)]);
    
    sc=((sz(1)-1)/2);
    u1=(i-(sz(2)-1)/2-1)/sc;
    u2=(j-(sz(1)-1)/2-1)/sc;
    
    
  case 'DivisionCam'
    ind = findstr(txt,'HEIGHT');
    m = sscanf(txt(ind:end),'HEIGHT=%d');
    
    ind = findstr(txt,'WIDTH');
    n = sscanf(txt(ind:end),'WIDTH=%d');
    
    ind = findstr(txt,'THETA_MAX');
    thmax = sscanf(txt(ind:end),'THETA_MAX=%f');
    
    ind = findstr(txt,'ic');
    ic = sscanf(txt(ind:end),'ic=%f');
    
    ind = findstr(txt,'jc');
    jc = sscanf(txt(ind:end),'jc=%f');
    
    ind = findstr(txt,'ab');
    ab= sscanf(txt(ind:end),'ab=%f,%f,%f,%f');
    
    %rotation hack
%     disp('rotating the camera projection (CSAIL5)');
%     c1p=-c3;
%     c2p=-c1;
%     c3p=c2;
    disp('rotating the camera projection (Gantry)');
    c1p=-c3;
    c2p=c1;
    c3p=-c2;
    
    ep=1E-9;
    center=find(abs(1-c1p)<ep);
    c1p(center)=ep;
    c1p(c1p<cos(thmax))=NaN;
    th=acos(c1p);
    th2=th.*th;
    r=(ab(1)*th+ab(2)*th2)./(1+ab(3)*th+ab(4)*th2);
    mag=sqrt(c2p.*c2p+c3p.*c3p);
    i=ic+r.*c3p./mag;
    j=jc+r.*c2p./mag;
    
    [u1,u2]=ij2u(i,j,m,n);

  otherwise
    error('unrecognized camera type');
end

end
