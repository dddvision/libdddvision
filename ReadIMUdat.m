function [time,gyro,accel]=ReadIMUdat(path,imufile)
% Reads inertial state files that were written by WriteIMUdat()
%
% ARGUMENTS:
%    path = directory for inertial data
% imufile = data file name
%    time = time stamp vector (1-by-(n+1))
%    gyro = gyroscope output (3-by-n)
%   accel = accelerometer output (3-by-n)
% Copyright 2006 David D. Diel, MIT License

fn=fullfile(path,imufile);

[a,b,c,d,e,f,g]=textread(fn,'%f\t%f\t%f\t%f\t%f\t%f\t%f');

time=a';
gyro=[b';c';d'];
accel=[e';f';g'];

return