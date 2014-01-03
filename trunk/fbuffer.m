% Captures a figure using hardcopy.
% 
% @param[in]  hFigure figure handle
% @param[out] cData   truecolor image data
function cData = fbuffer(hFigure)
  units = get(hFigure, 'Units');
  set(hFigure, 'Units', 'pixels');
  position = get(hFigure, 'Position');

  paperPositionMode = get(hFigure, 'PaperPositionMode');
  set(hFigure, 'PaperPositionMode', 'Manual');
  
  paperUnits = get(hFigure, 'PaperUnits');
  set(hFigure, 'PaperUnits', 'inches');
  paperPosition = get(hFigure, 'PaperPosition');
  
  invertHardcopy = get(hFigure, 'InvertHardcopy');
  set(hFigure, 'InvertHardcopy', 'off');
  
  if(strcmp(get(hFigure, 'Renderer'), 'opengl'))
    sPPI = get(0, 'ScreenPixelsPerInch');
    set(hFigure, 'PaperPosition', [0.0, 0.0, position(3)/sPPI, position(4)/sPPI]); 
    cData = hardcopy(hFigure, '-dopengl', '-r0');
  else
    sPPI = get(0, 'ScreenPixelsPerInch');
    set(hFigure, 'PaperPosition', [0.0, 0.0, position(3)/sPPI, position(4)/sPPI]); 
    cData = hardcopy(hFigure, '-dzbuffer', '-r0');
  end
  if(numel(cData)>(position(3)*position(4)*3))
    cData = cData(1:position(4), 1:position(3), :);
  end

  set(hFigure, 'InvertHardcopy', invertHardcopy);
  set(hFigure, 'PaperUnits', paperUnits);
  set(hFigure, 'PaperPosition', paperPosition);
  set(hFigure, 'PaperPositionMode', paperPositionMode);
  set(hFigure, 'Units', units);
  set(hFigure, 'Position', position);
end
