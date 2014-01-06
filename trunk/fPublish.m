% Saves a figure as an image using high quality print options.
% 
% @param[in] hFigure  figure handle
% @param[in] fileName name of image file to write with extension
function fPublish(hFigure, fileName)
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
    renderer = '-opengl';
  else
    renderer = '-zbuffer';
  end
  
  sPPI = get(0, 'ScreenPixelsPerInch');
  set(hFigure, 'PaperPosition', [0.0, 0.0, position(3), position(4)]/sPPI);

  [filePath, fileStub, fileExt] = fileparts(fileName);
  if(strcmpi(fileExt, '.png'))
    print(hFigure, '-dpng', renderer, '-r300', fileName);
  else
    pngFileName = [fileName, '.png'];
    print(hFigure, '-dpng', renderer, '-r300', pngFileName);
    cData = imread(pngFileName);
    fprintf('%s\n', result);
    if(status==0)
      delete(pngFileName);
    end
    imwrite(cData, fileName);
  end

  set(hFigure, 'InvertHardcopy', invertHardcopy);
  set(hFigure, 'PaperUnits', paperUnits);
  set(hFigure, 'PaperPosition', paperPosition);
  set(hFigure, 'PaperPositionMode', paperPositionMode);
  set(hFigure, 'Units', units);
  set(hFigure, 'Position', position);
end
