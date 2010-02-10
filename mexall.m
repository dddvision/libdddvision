mex Plugger\MEXTopBotEdges.cpp -g -argcheck -IPlugger -IAngularCalibration -outdir Plugger
mex Plugger\MEXTestCorners.cpp -g -argcheck -IPlugger -IAngularCalibration -outdir Plugger
mex Plugger\MEXFindCorners.cpp -g -argcheck -IPlugger -IAngularCalibration -outdir Plugger

mex Minclude\MEXAngularCalibration.cpp -g -argcheck -IPlugger -IAngularCalibration -outdir Minclude

mex Minclude\MEXinterp2v.cpp -g -argcheck -outdir Minclude

mex Minclude\MEXinterp2vex.cpp -g -argcheck -outdir Minclude

mex Minclude\MEXtrackFeaturesKLT.cpp -g -argcheck -outdir Minclude

mex Minclude\MEXmanageFeatures.cpp -g -argcheck -outdir Minclude

disp('Done compiling MEX files');