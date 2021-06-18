% Copyright 2006 David D. Diel, MIT License
fprintf('\nMaking MEXcvExtractSurf.cpp....');
userPath = path;
userWarnState=warning('off','all'); % see MATLAB Solution ID 1-5JUPSQ
addpath(getenv('LD_LIBRARY_PATH'),'-END');
addpath(getenv('PATH'),'-END');
warning(userWarnState);
if(ispc)
  libdir=fileparts(which('cv110.lib'));
elseif(ismac)
  libdir=fileparts(which('libcv.dylib'));
else
  libdir=fileparts(which('libcv.so'));
end
path(userPath);
userDirectory = pwd;
try
  if(ispc)    
    mex('MEXcvExtractSURF.cpp',['-L"',libdir,'"'],'-lcv110','-lcxcore110', '-lhighgui110', '-lcvaux110');
  elseif(ismac)
    mex('MEXcvExtractSURF.cpp',['-L"',libdir,'"'],'-lcv','-lcxcore', '-lhighgui', '-lcvaux');
  else
    mex('MEXcvExtractSURF.cpp',['-L"',libdir,'"'],'-lcv','-lcxcore', '-lhighgui', '-lcvaux');
  end
catch err
   details =['mex fail' err.message];
   cd(userDirectory);
   error(details);
end
cd(userDirectory);     
fprintf('Done\n');
