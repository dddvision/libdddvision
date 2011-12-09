% check MATLAB version
try
  matlabVersion=version('-release');
catch err
  error('%s. Implement MATLAB Solution ID 1-5JUPSQ and restart MATLAB', err.message);
end
if(str2double(matlabVersion(1:4))<2008)
  error('\nRequires MATLAB version 2008a or greater');
end

% close figures and clear everything except breakpoints
breakpoints = dbstatus('-completenames');
save('breakpoints.mat', 'breakpoints');
close('all');
clear('all');
clear('classes');
load('breakpoints.mat');
dbstop(breakpoints);

% set the warning state
warning('on','all');
warning('off','MATLAB:intMathOverflow'); % see performance remark in "doc intwarning"

% initialize the default pseudorandom number generator
RandStream.getGlobalStream.reset();
