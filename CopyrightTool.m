function varargout = CopyrightTool(varargin)
%      COPYRIGHTTOOL, by itself, creates a new COPYRIGHTTOOL or raises the existing
%      singleton*.
%
%      H = COPYRIGHTTOOL returns the handle to a new COPYRIGHTTOOL or the handle to
%      the existing singleton*.
%
%      COPYRIGHTTOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COPYRIGHTTOOL.M with the given input arguments.
%
%      COPYRIGHTTOOL('Property','Value',...) creates a new COPYRIGHTTOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CopyrightTool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CopyrightTool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% Copyright 2021 David D. Diel, MIT License

% Last Modified by GUIDE v2.5 03-Jun-2021 18:48:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CopyrightTool_OpeningFcn, ...
                   'gui_OutputFcn',  @CopyrightTool_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

function updateSelection(handles)
updateSummary(handles);
updatePreview(handles);


function updatePreview(handles)
fullname = getFullName(handles);
s = getText(fullname);
handles.Preview.String = s;


function updateSummary(handles)
name = getName(handles);
cprt = getCopyrightFromFile(handles, name);
handles.FileList.String{handles.FileList.Value} = toSummary(name, cprt);


function s = getText(fullname)
s = urlread(['file://', fullname]);
s = strrep(s, sprintf('\r\n'), newline);


function putText(fullname, s)
s = strrep(s, sprintf('\r\n'), newline);
s = strrep(s, newline, sprintf('\r\n'));
fid = fopen(fullname, 'wt');
fprintf(fid, '%s', s);
fclose(fid);


function line = toSummary(name, cprt)
N = numel(name);
if(N<30)
  name = [name, repmat(' ', 1, 30-N)];
elseif(N>30)
  name = name(1:30);
end
line = [name, '|', cprt];


function cprt = getCopyrightFromFile(handles, name)
cprt = '';
fid = fopen(fullfile(handles.SelectFolder.String, name), 'rt');
for k = 1:1000
  line = fgetl(fid);
  if(~ischar(line))
    break;
  end
  sline = string(line);
  if(sline.contains({'copyright ', 'public domain'}, 'IgnoreCase', true))
    cprt = line;
    break;
  end
end
fclose(fid);


function cprt = getCopyright(handles)
rights = handles.Rights.String{handles.Rights.Value};
if(strcmp(rights, 'Public Domain'))
  cprt = rights;
else
  year = handles.Year.String{handles.Year.Value};
  owner = handles.Owner.String{handles.Owner.Value};
  license = handles.License.String{handles.License.Value};
  cprt = [rights, ' ', year, ' ', owner, ', ', license];
end


function name = getName(handles)
contents = cellstr(get(handles.FileList, 'String'));
line = contents{get(handles.FileList, 'Value')};
index = find(line=='|', 1);
if(isempty(index))
  name = line;
else
  name = line(1:(index-1));
  sname = string(name);
  name = char(sname.strip('right'));
end


function fullname = getFullName(handles)
name = getName(handles);
fullname = fullfile(handles.SelectFolder.String, name);


function i = findInsertionPoint(s, prefix)
N = numel(s);
i = 0;
j = findNextLine(i, s, newline, N);
% if there is no chance of a comment on the next line
if((j==0)||(j>=(N-2)))
  return;
end
% if this is a MATLAB file and the first line is not a comment
if(isequal(prefix, '%')&&(s(1)~='%'))
  % skip a line
  i = findNextLine(i, s, newline, N);
end
% if the next character could be an escape
if(s(i+1)==prefix(1))
  % if c-style comment
  if(prefix(1)=='/')
    % if multiline comment
    if(s(i+2)=='*')
      % find the close of the comment
      token = strtok(s, '*/');
      i = findNextLine(numel(token)+2, s, newline, N);
      return;
    elseif(s(i+2)=='/')
      % find the next line
      while(i<(N-2))
        i = findNextLine(i, s, newline, N);
        if(s(i+1)~=prefix(1))
          return;
        end
      end
    end
  else
    % single line comment
    while(i<(N-2))
      i = findNextLine(i, s, newline, N);
      if(s(i+1)~=prefix(1))
        return;
      end
    end
  end
end


function j = findNextLine(i, s, nl, N)
% Finds the last index prior to the next line.
j = i+1;
while(j<=N)
  if(s(j)==nl)
    break;
  end
  j = j+1;
end


function CopyrightTool_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);


function varargout = CopyrightTool_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


function SelectFolder_Callback(hObject, eventdata, handles)
folder = uigetdir(pwd, 'Select folder');
handles.SelectFolder.String = folder;
files = dir(folder);
F = numel(files);
handles.FileList.String = {};
for f = 1:F
  if(~files(f).isdir)
    name = files(f).name;
    sname = string(name);
    if(sname.endsWith({'.m', '.py', '.pyx', '.c', '.cpp', '.h', '.hpp'}))
      cprt = getCopyrightFromFile(handles, name);
      line = toSummary(name, cprt);
      handles.FileList.String = cat(1, handles.FileList.String, {line});
    end
  end
end
updateSelection(handles);


function FileList_Callback(hObject, eventdata, handles)
updateSelection(handles);



function Rights_CreateFcn(hObject, eventdata, handles)
hObject.String = {'Copyright','Public Domain'};


function Year_CreateFcn(hObject, eventdata, handles)
hObject.String = {'2002','2006','2011','2021'};


function Owner_CreateFcn(hObject, eventdata, handles)
hObject.String = {'David D. Diel','Scientific Systems Company Inc.','University of Central Florida'};


function License_CreateFcn(hObject, eventdata, handles)
hObject.String = {'MIT License','New BSD License','All Rights Reserved'};



function Replace_Callback(hObject, eventdata, handles)
Remove_Callback(hObject, eventdata, handles);
Append_Callback(hObject, eventdata, handles);


function Append_Callback(hObject, eventdata, handles)
fullname = getFullName(handles);
sfullname = string(fullname);
if(sfullname.endsWith('.m'))
  prefix = '%';
elseif(sfullname.endsWith({'.py', '.pyx'}))
  prefix = '#';
else
  prefix = '//';
end
cprt = getCopyright(handles);
cprt = sprintf('%s %s\n', prefix, cprt);
s = getText(fullname);
index = findInsertionPoint(s, prefix);
s = [s(1:index), cprt, s((index+1):end)];
handles.Preview.String = s;
putText(fullname, s);
updateSelection(handles);


function Remove_Callback(hObject, eventdata, handles)
name = getName(handles);
cprt = getCopyrightFromFile(handles, name);
fullname = getFullName(handles);
if(~isempty(cprt))
  s = getText(fullname);
  cprt = [cprt, newline];
  s = strrep(s, cprt, '');
  handles.Preview.String = s;
  putText(fullname, s);
  updateSelection(handles);
end


function Edit_Callback(hObject, eventdata, handles)
fullname = getFullName(handles);
system(['open ', fullname, ' -a Xcode -W']);
updateSelection(handles);
