% Example of a trivial class.
%
% >> c = Counter();
% >> c.count
% ans = 1
% >> c.count
% ans = 2
% >> c.count
% ans = 3
% Public Domain
classdef Counter < handle
  properties
    x
  end
  
  methods
    function y = count(this)
      if(isempty(this.x))
        this.x = 0;
      end
      this.x = this.x+1;
      y = this.x;      
    end
  end
end
