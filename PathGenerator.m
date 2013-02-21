function Qout=PathGenerator(To,Tf,method,arg)
% Generates a parametric path
% Unwraps rotation increments
% 
% t = symbolic parameter for time
% method = 'Zeros','EulerTrans','ReadKeys','ReadNavDat'
% arg = parameters required by the method
% Qout = symbolic expressions for rotation and translation (7-by-1)

switch method

case 'Zeros'
  Qout=sym([1;0;0;0;0;0;0]);
  
case 'EulerTrans'
  a=sym(arg{1});
  b=sym(arg{2});
  c=sym(arg{3});
  q5=sym(arg{4});
  q6=sym(arg{5});
  q7=sym(arg{6});

  quat=tom.Rotation.eulerToQuat([a;b;c]);
  Qout=[quat(1);quat(2);quat(3);quat(4);q5;q6;q7];

case 'ReadKeys' %requires arg={filename,RSP}
  RSP=arg{2}; %(sec) resampling period
  
  %read the motion file
  [T,X,Q,Qd,K]=ReadKeys(arg{1});

  %convert rotation rates to axis-angle form
  vdot=zeros(3,K);
  for i=1:K
    vdot(:,i)=invJexp(Q(:,i),1)*Qd(:,i);
  end

  %sample times
  N=(Tf-To)/RSP;
  Ti=To+(Tf/N)*[0:N];

  %resample
  Qi=QuatInterp('hermite',Q,T,Ti,vdot);
  Xi=TransInterp('controlled',X,T,Ti);

  [Qt,Xt]=PathGenerator_Fourier(Qi,Xi,RSP,N);

  Qout=[Qt;Xt];

case 'ReadNavDat'
  RSP=1/10; %(sec) resampling period

  %read the motion file
  [T,X,Xd,Q,Qd,K]=ReadNavDat(arg{1});

  %convert rotation rates to axis-angle form
  vdot=zeros(3,K);
  for i=1:K
    vdot(:,i)=invJexp(Q(:,i),1)*Qd(:,i);
  end

  %sample times
  N=(Tf-To)/RSP;
  Ti=To+(Tf/N)*[0:N];

  %resample
  Qi=QuatInterp('hermite',Q,T,Ti,vdot);
  Xi=TransInterp('cubic',X,T,Ti);

  [Qt,Xt]=PathGenerator_Fourier(Qi,Xi,RSP,N);

  Qout=[Qt;Xt];

otherwise
  error('invalid method');

end

end


function [Qt,Xt]=PathGenerator_Fourier(Qi,Xi,RSP,N)
  %precision of fourier spline coefficients
  PRECISION=5;

  %convert to Euler angles
  Ei=unwrap(tom.Rotation.quatToEuler(Qi)')';

  %fourier transform
  EXi=[Ei;Xi];
  FEX=fft([EXi,fliplr(EXi)],2*N,2);
  
  %calculate frequencies
  kmax=N/2;
  a0=FEX(:,1)/(2*N);
  a=2*real(FEX(:,2:kmax+1))/(2*N);
  b=-2*imag(FEX(:,2:kmax+1))/(2*N);

  %create symbolic fourier curve
  syms t real
  wk=vpa(2*pi/(2*N*RSP),9);
  EX=sym(zeros(6,1));
  for j=1:6
    %sort descending
    [as,ai]=sort(abs(a(j,:)));
    [bs,bi]=sort(abs(b(j,:)));
    as=fliplr(as);
    ai=fliplr(ai);
    bs=fliplr(bs);
    bi=fliplr(bi);

    %remove insignificant coefficients
    IC=find(as<(as(1)/500));
    if ~isempty(IC)
      kmax=IC(1);
    end

    %replace signs of coefficients
    as=as.*sign(a(j,ai));
    bs=bs.*sign(b(j,bi));

    %reduce the precision of remaining coefficients
    as=vpa(as,PRECISION);
    bs=vpa(bs,PRECISION);

    %assemble the fourier series
    EX(j)=vpa(a0(j),PRECISION);
    for k=1:kmax
      EX(j)=EX(j)+as(k)*cos(wk*ai(k)*t)+bs(k)*sin(wk*bi(k)*t);
    end
  end

  %convert output to quaternions
  Qt=vpa(tom.Rotation.eulerToQuat(EX(1:3,1)),PRECISION);
  Xt=EX(4:6,1);

end
