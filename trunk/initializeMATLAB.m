% check MATLAB version
try
  matlabVersionString = version('-release');
  matlabVersion = str2double(matlabVersionString(1:4));
catch err
  error('%s. Implement MATLAB Solution ID 1-5JUPSQ and restart MATLAB', err.message);
end
if(matlabVersion<2009)
  error('\nRequires MATLAB version 2009a or greater');
end

% initialize the default pseudorandom number generator
if(matlabVersion<2010)
  RandStream.getDefaultStream.reset(); %#ok supports legacy versions
else
  RandStream.getGlobalStream.reset();
end

% close figures and clear everything except breakpoints
close('all');
breakpoints = dbstatus('-completenames');
save('breakpoints.mat', 'breakpoints');
evalin('base', 'clear(''classes'')');
load('breakpoints.mat');
delete('breakpoints.mat');
dbstop(breakpoints);
clear('breakpoints');

% set the warning state
warning('on','all');
warning('off','MATLAB:intMathOverflow'); % see performance remark in "doc intwarning"
