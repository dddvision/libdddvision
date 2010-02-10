








function xdot=PathAverage_ODE(ti,x,junk,f)

  xdot=feval(inline(char(f)),ti);

return
