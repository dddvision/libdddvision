function []=WriteIMUdat(path,imufile,time,gyro,accel)
% Writes inertial state data to a file
%
% ARGUMENTS:
%    path = directory in which to write the file
% imufile = name of the file 
%    time = time stamp vector (1-by-n))
%    gyro = gyroscope output (3-by-(n-1))
%   accel = accelerometer output (3-by-(n-1))

[m,n]=size(time);
if m~=1
  error('time stamp vector must be 1-by-n');
end
time=time(2:end);
n=n-1;

[gm,gn]=size(gyro);
if (gm~=3)|(gn~=n)
  error('gyro data must be 3-by-(n-1)');
end
[am,an]=size(accel);

if (am~=3)|(an~=n)
  error('accelerometer data must be 3-by-(n-1)');
end

states=[time;gyro;accel];

fn=fullfile(path,imufile);
fid=fopen(fn,'wt');
  fprintf(fid,'%0.9E\t%+0.9E\t%+0.9E\t%+0.9E\t%+0.9E\t%+0.9E\t%+0.9E\n',states);
fclose(fid);

return