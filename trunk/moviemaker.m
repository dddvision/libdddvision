close all;
clear classes;
drawnow;

%filename settings
INPUT_DIRECTORY='/projects/InertiaPlusImages/scenes/Desert/';
INPUT_STUB='desert';
INPUT_EXT='.bmp';
OUTPUT_DIRECTORY='/projects/InertiaPlusImages/scenes/Desert/';
OUTPUT_STUB='test';
NUMBER_FORMAT='%04d';
FRAME_BEGIN=0;
FRAME_INC=1;
FRAME_END=1680; % can be Inf
SHOW_IMAGES=false;

%Codec playback settings
COMPRESSION='none'; %('FFDS'),'Indeo5','Cinepak','MPG4' (size must be N*16)
FPS=15; %(12.595 for Lumenera) frames per second
KEY_FPS=1; %(1/8) is typical for MPG4
QUALITY=100; %(100), does not affect Cinepak

%OPEN THE MOVIE FILE
mov=avifile([fullfile(OUTPUT_DIRECTORY,OUTPUT_STUB),'.avi'],'Fps',FPS,'Compression',COMPRESSION,'Quality',QUALITY,'KeyFramePerSec',KEY_FPS,'VideoName',OUTPUT_STUB);

try
  for frame = FRAME_BEGIN:FRAME_INC:FRAME_END
    fprintf('\n%d',frame);
    
    [X,MAP]=imread(fullfile(INPUT_DIRECTORY,[INPUT_STUB,num2str(frame,NUMBER_FORMAT),INPUT_EXT])); 
    %[Y,YMAP]=imread(fullfile('/home/ddiel/flight47/Combined',[num2str(frame,NUMBER_FORMAT),INPUT_STUB,INPUT_EXT])); 
    %X=uint8(ReadBinPGM([fullfile(INPUT_DIRECTORY,INPUT_STUB),num2str(frame,NUMBER_FORMAT),INPUT_EXT]));
    %MAP=gray(256);
    
    F=im2frame(X,MAP);
    %G=im2frame(Y,YMAP);
    %F.cdata=[F.cdata,uint8(128*ones(size(F.cdata,1),8,3)),G.cdata]; %hack to join two frames

    % rotate
    %F.cdata=cat(3,rot90(F.cdata(:,:,1)),rot90(F.cdata(:,:,2)),rot90(F.cdata(:,:,3)));

%     % UserDemo
%     [X,MAP]=imread([fullfile(INPUT_DIRECTORY,INPUT_STUB),num2str(frame,NUMBER_FORMAT),'.blips.png']); 
%     [Y,YMAP]=imread([fullfile(INPUT_DIRECTORY,INPUT_STUB),num2str(frame,NUMBER_FORMAT),'.density.png']); 
%     F=im2frame(X,MAP);
%     G=im2frame(Y,YMAP);
     %F.cdata=cat(2,F.cdata,G.cdata);

    % pad
%     BLOCK_SIZE=16;
%     [m,n,p]=size(F.cdata);
%     mr=(BLOCK_SIZE-mod(m,BLOCK_SIZE))/2;
%     nr=(BLOCK_SIZE-mod(n,BLOCK_SIZE))/2;
%     F.cdata=cat(1,zeros(floor(mr),n,p),F.cdata,zeros(ceil(mr),n,p));
%     F.cdata=cat(2,zeros(m+2*mr,floor(nr),p),F.cdata,zeros(m+2*mr,ceil(nr),p));
  
    % resize
%   OUTPUT_WIDTH=896; 
%   OUTPUT_HEIGHT=448; % must be multiple of 16 for MPG4
%     [m,n,p]=size(F.cdata);
%     mratio=OUTPUT_HEIGHT/m;
%     nratio=OUTPUT_WIDTH/n;
%     if( (mratio~=1) || (nratio~=1) )
%       scale=min(mratio,nratio);
%       F.cdata=imresize(F.cdata,scale,'bicubic');
%       [m,n,p]=size(F.cdata);
%       mpad=(OUTPUT_HEIGHT-m)/2;
%       npad=(OUTPUT_WIDTH-n)/2;
%       if( mpad )
%         F.cdata=cat(1,zeros(floor(mpad),OUTPUT_WIDTH,p),F.cdata,zeros(ceil(mpad),OUTPUT_WIDTH,p));
%       elseif( npad )
%         F.cdata=cat(2,zeros(OUTPUT_HEIGHT,floor(npad),p),F.cdata,zeros(OUTPUT_HEIGHT,ceil(npad),p));    
%       end
%     end

    mov=addframe(mov,F);

    if SHOW_IMAGES
      figure(1),cla,imshow(F.cdata);
    end
  end
catch err
  fprintf('\n%s',err.message);
  fprintf('\nDone');
end
mov = close(mov);
