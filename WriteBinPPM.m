function WriteBinPPM(im, fileName)
% Copyright 1999 Sohaib Kahn, MIT License

fid = fopen(fileName, 'w');
if fid<0
   error(['Error opening file ... ' fileName]);
end;

fwrite(fid, ['P6', 10, int2str(size(im,2)),' ',int2str(size(im,1)),10,'255',10],'uchar');

a = zeros(size(im, 1), 3*size(im,2));
a(:,1:3:size(a,2))=im(:,:,1);
a(:,2:3:size(a,2)) = im(:,:,2);
a(:,3:3:size(a,2)) = im(:,:,3);

fwrite(fid, a', 'char');

fclose(fid);
