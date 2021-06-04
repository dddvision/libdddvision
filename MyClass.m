% Example of a class with a few methods.
%
% Usage:
% >> c = MyClass(1);
% >> c.getState()
% ans = 1
% >> c.setState(2)
% >> c.getState()
% ans = 2
% >> c.operate(3)
% ans = 5
% >> c.delete()
% Public Domain
classdef MyClass < handle
  properties (GetAccess = private, SetAccess = private)
    state
  end
  
  methods (Access = public)
    function this = MyClass(x0)
      this.state = x0;
    end
    
    function setState(this, x)
      this.state = x;
    end
    
    function x = getState(this)
      x = this.state;
    end
    
    function z = operate(this, y)
      z = this.state+y;
    end

    function delete(this)
      this.state = [];
    end
  end
end
