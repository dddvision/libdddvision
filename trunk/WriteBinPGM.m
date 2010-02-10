function WriteBinPGM(im, fileName)
%WRITEPGM 	writes a grayscale PGM file [0,255]

% sohaib khan\
% 14th July 1999

fid = fopen(fileName, 'w');
if fid < 3
   error(['unable to open ' fileName]);
end;

fwrite(fid,['P5',10,int2str(size(im,2)),' ',int2str(size(im,1)),10,'255',10],'uchar');	%10 is return
fwrite(fid,im','char');		%be careful of this transpose operation
									% reason is that matlab scanning order is not the same as every1 else

fclose(fid);