% Captures a figure via an offscreen buffer
% 
% INPUT
% hfig = handle to a matlab figure
% 
% OUTPUT
% cdata = color image in uint8, M-by-N-by-3
%
% TODO: update pos(1:2) if figure/axis units are normalized
function cdata = fbuffer(hfig)

  pos = get(hfig, 'Position');

  if(strcmp(get(hfig, 'Renderer'), 'opengl'))
    sppi = get(0, 'ScreenPixelsPerInch');
    ppos = get(hfig, 'PaperPosition');
    pos(1:2) = 0;
    set(hfig, 'PaperPosition', pos./sppi);
    cdata = hardcopy(hfig, '-dopengl', ['-r', num2str(round(sppi))]);
    set(hfig, 'PaperPosition', ppos);
  else
    mode = get(hfig, 'PaperPositionMode');
    set(hfig, 'PaperPositionMode', 'auto', 'InvertHardcopy', 'off');
    cdata = hardcopy(hfig, '-dzbuffer', '-r0');
    set(hfig, 'PaperPositionMode', mode);
  end

  if(numel(cdata)>(pos(3)*pos(4)*3))
    cdata = cdata(1:pos(4), 1:pos(3), :);
  end
end
