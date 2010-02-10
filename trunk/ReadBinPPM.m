function [RGB]=ReadBinPPM(fileName)
% READBINPPM	reads a binary PPM file and returns an m-by-n-by-3 matrix in [0..255]

%Sohaib Khan: June 16 1999

fid = fopen(fileName, 'r');
if (fid <0)
   error('error opening file...');
end;

type  = fgetl(fid);		% reading 'magic number');
if (type ~= 'P6')
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

%initializations
r=zeros(rows,cols);
g=zeros(rows,cols);
b=zeros(rows,cols);


% reading data values

wholeImage=fread(fid,[3*cols,rows],'uint8');
wholeImage=wholeImage';
r=wholeImage(:,1:3:3*cols);
g=wholeImage(:,2:3:3*cols);
b=wholeImage(:,3:3:3*cols);

RGB = cat(3, r, g, b);

fclose(fid);

