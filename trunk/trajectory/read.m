% Read data from a file and interpret it as the given type
%
% INPUT
% fname = name of the file to read from
% type = string that identifies a user-defined trajectory type
%








function this=read(this,fname,type)

switch(type)
  case {'gotcha','geko'}
    fid=fopen(fname);
    data=fread(fid,Inf,'char=>char');
    fclose(fid);

  otherwise
    error('unhandled exception');
end

this=trajectory(type,data);

return;
