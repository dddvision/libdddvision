function [im]=ReadBinPGM(fileName)
% Copyright 2002 University of Central Florida, MIT License

fid = fopen(fileName, 'r');
if (fid < 0)
   error(['error opening file... ', fileName]);
end;

type = fgetl(fid);

if (type ~= 'P5')
   error('invalid magic number in file');
end;
   
comment = fgetl(fid);
if (comment(1) ~= '#')
   size = str2num(comment);
   cols = size(1);
   rows = size(2);
else
   cols = fscanf(fid,'%d',1);		% width of image
   rows  = fscanf(fid,'%d',1);		% height of image
   fgetl(fid);
end;

maxcolorvalue=fgetl(fid);	% not needed in this code

im=fread(fid,[cols,rows],'uint8');
im=im';

fclose(fid);


