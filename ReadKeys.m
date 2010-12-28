% Loads motion data from a file
%
% INPUT
% filename = name of the file containing key poses
%
% OUTPUT
%  T = time stamp vector in seconds (1-by-n)
%  X = body positions in world frame in meters (3-by-n)
%  Q = quaternion orientation of Forward-Right-Down frame relative to world frame (4-by-n)
% Qd = quaternion rates (4-by-n)
%  n = number of keys read
%
% NOTES
% The input file is tab separated in the following format
%
% T  X  Y  Z  A  B  C  D  E  F
%    . . .
%    . . .
%
% T = time stamp in seconds
% X = North in meters
% Y = East in meters
% Z = Geodetic Down in meters
% A = Euler pan right in degrees
% B = Euler tilt up in degrees
% C = Euler spin clockwise in degrees
% D = pan right about rotated A axis in degrees per second
% E = tilt up about rotated B axis in degrees per second
% F = spin clockwise about rotated C axis in degrees per second
function [T, X, Q, Qd, n] = ReadKeys(filename)

  % read keyframe data
  K = dlmread(filename);

  K = K'; % transpose
  [m, n] = size(K);

  if(m~=10)
    error([filename, ' must contain m-by-10 tab delimited matrix']);
  end

  if(sum(K(:, end)==0)==10)
    fprintf('\nwarning: last line of keyframe file contains zeros or whitespace'); 
  end

  % extract time stamp
  T = K(1, :);
  if(sum(double(diff(T)<0.000001))>0)
    error('keyframe times must increase monotonically and significantly');
  end

  % extract position
  X = K(2:4, :);

  % convert to radians
  K(5:10, :) = K(5:10, :)*(pi/180);

  % extract Euler angles
  pan = K(5, :);
  tilt = K(6, :);
  spin = K(7, :);

  % extract Euler rates (reverse order)
  er(3, :) = K(8, :);
  er(2, :) = K(9, :);
  er(1, :) = K(10, :);

  % convert from pan-tilt-spin (reverse order) to scalar-vector quaternions
  Q = Euler2Quat([spin; tilt; pan]);

  Qd = zeros(4, n);
  for i = 1:n
    Qd(:, i) = 0.5*Quat2Homo(Q(:, i))*[0; er(:, 1)]; % qd = 1/2*q*omega
  end

end
