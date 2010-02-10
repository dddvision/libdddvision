% Load a trajectory object from a file
%









function this=load(this,fname)
try
  this=getfield(load(fname,'trajectory','-mat'),'trajectory');
catch
  this=struct('type',{},'data',{});  
end
this=trajectory('trajectory',this);
return;
