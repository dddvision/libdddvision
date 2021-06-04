function [Gout,Aout]=IMUSim(dtheta,fav,Ts,IMU,RANDOM_SEED)
% DESCRIPTION
%   Corrupts clean IMU data with noise, according to a bias, scale, and random walk model.
%   The bias and scale factors vary slowly over time.
%
% ARGUMENTS
% dtheta = clean gyro signal, "discrete omega" (3-by-n) (rad/sec)
%    fav = clean accelerometer signal, "discrete specific force" (3-by-n) (meters/sec^2)
%     Ts = sampling period (1-by-1) (sec)
%    IMU = structure produced by custom function IMUModel()
%
% RETURN
%   Gout = noisy gyro output signal (rad/sec)
%   Aout = noisy accelerometer output signal (meters/sec^2)
%
% Copyright 2006 David D. Diel, MIT License
if RANDOM_SEED
  randn('seed',RANDOM_SEED);
end

%call the noise simulator for each gyro axis
[m,n]=size(dtheta);
Gout=zeros(m,n);
for i=1:m
  Gout(i,:)=BSRsim(dtheta(i,:),Ts,IMU.Gyro);
end

%call the noise simulator for each accelerometer axis
[m,n]=size(fav);
Aout=zeros(m,n);
for i=1:m
  Aout(i,:)=BSRsim(fav(i,:),Ts,IMU.Accel);
end
  
return


%subfunction to implement the noise model
function Y=BSRsim(X,Ts,Sensor)

N=size(X,2);

%bias model
TurnOn=Sensor.Bias.TurnOn;
Tau=Sensor.Bias.Tau;
InRunDriver=Sensor.Bias.InRun*sqrt(2/Tau/Ts-(1/Tau)^2);
if Tau<Ts
  warning('IMU bias time constant should be longer than one time step');
end
BIAS=TurnOn*randn + lsim(ss(1-Ts/Tau,Ts*InRunDriver,1,0,Ts),randn(1,N))';

%scale model
TurnOn=Sensor.Scale.TurnOn;
Tau=Sensor.Scale.Tau;
InRunDriver=Sensor.Scale.InRun*sqrt(2/Tau/Ts-(1/Tau)^2);
if Tau<Ts
  warning('IMU scale factor time constant should be longer than one time step');
end
SCALE=TurnOn*randn + lsim(ss(1-Ts/Tau,Ts*InRunDriver,1,0,Ts),randn(1,N))';

%random walk
RandomWalk=Sensor.RandomWalk;
RANDOM=RandomWalk/sqrt(Ts)*randn(1,N);

%combined output
Y = X + BIAS + SCALE.*X + RANDOM;

return 
