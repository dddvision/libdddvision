% Get SVN revision number.
function rev = getSVNRevision(fileName)
persistent svnapp
if(nargin==0)
  fileName = '.';
end
if(isempty(svnapp))
  if(ispc)
    svnapp = 'C:\Program Files\TortoiseSVN\bin\svn.exe';
  else
    [status, result] = system('which svn');
    if(status)
      error('%s', result);
    end
    svnapp = strtrim(result);
  end
end
cmd = [svnapp, ' info ', fileName];
[status, result] = system(cmd);
if(status)
  error('%s', result);
end
rev = regexp(result, 'Revision: (\d+)', 'tokens', 'once');
rev = str2double(rev{1});
end
