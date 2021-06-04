function xdot=PathAverage_ODE(ti,x,junk,f)
% Copyright 2006 David D. Diel, MIT License
  xdot=feval(inline(char(f)),ti);
end
