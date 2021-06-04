close all;
% Copyright 2006 David D. Diel, MIT License
clear classes;
drawnow;

% new method
% videoName = 'fgDemo.avi';
% frameRate = 30;
% quality = 95;
% vr = VideoWriter(videoName);
% vr.FrameRate = frameRate;
% vr.Quality = quality;
% vr.open();
% d = dir('scene*');
% for n = 1:numel(d)
%   imageName = d(n).name;
%   fprintf('%s\n', imageName);
%   img = imread(imageName);
%   vr.writeVideo(img);
% end
% vr.close()

% parameters
inputDirectory = '/home/ddiel/1435-1/Simulator/';
outputDirectory = '/home/ddiel/1435-1/Simulator/';
inputStub = eval(['{''', strrep(strrep(strrep(num2str((0.5:0.5:20.5).*mod(0:40, 2), '%05d. '), '  ', ' '), '  ', ' '), ' ', ''','''), '''};']);
inputExtension = '.png';
outputStub = 'video';
numberFormat = '%05d';
frame = 0:29;
showImages = true;
compression = 'none'; %('FFDS'),'Indeo5','Cinepak','MPG4' (size must be N*16)
frameRate = 15; %(12.595 for Lumenera) ks per second
fpsKey = 1; %(1/8) is typical for MPG4
quality = 100; %(100), does not affect Cinepak

% open the movie file
mov = avifile([fullfile(outputDirectory, outputStub),'.avi'], 'Fps', frameRate, 'Compression', compression, 'Quality', quality, 'KeyFramePerSec', fpsKey, 'VideoName', outputStub);

try
  for s = 1:numel(inputStub)
    for k = 1:numel(frame)
      fprintf('\n%d', k);

      if(strcmp(inputStub{s}, '00000.'))
        X = zeros(512, 640, 3);
      else
        X = imread(fullfile(inputDirectory, [inputStub{s}, num2str(frame(k), numberFormat), inputExtension]));
        X = repmat(double(X)/255.0, [1, 1, 3]);
      end
%       [Y, YMAP] = imread(fullfile('/home/ddiel/flight47/Combined', [num2str(k, numberFormat), inputStub, inputExtension])); 
%       X = uint8(ReadBinPGM([fullfile(inputDirectory, inputStub), num2str(k, numberFormat), inputExtension]));

      F = im2frame(X, []);
%       G = im2frame(Y, YMAP);
%       F.cdata = [F.cdata, uint8(128*ones(size(F.cdata, 1), 8, 3)), G.cdata]; %hack to join two ks
%       
%       % rotate
%       F.cdata = cat(3, rot90(F.cdata(:, :, 1)), rot90(F.cdata(:, :, 2)), rot90(F.cdata(:, :, 3)));
%       
%       % UserDemo
%       [X, MAP] = imread([fullfile(inputDirectory, inputStub), num2str(k, numberFormat), '.blips.png']);
%       [Y, YMAP] = imread([fullfile(inputDirectory, inputStub), num2str(k, numberFormat), '.density.png']);
%       F = im2frame(X, MAP);
%       G = im2frame(Y, YMAP);
%       F.cdata = cat(2, F.cdata, G.cdata);
%       
%       % pad
%       BLOCK_SIZE = 16;
%       [m, n, p] = size(F.cdata);
%       mr = (BLOCK_SIZE-mod(m, BLOCK_SIZE))/2;
%       nr = (BLOCK_SIZE-mod(n, BLOCK_SIZE))/2;
%       F.cdata = cat(1, zeros(floor(mr), n, p), F.cdata, zeros(ceil(mr), n, p));
%       F.cdata = cat(2, zeros(m+2*mr, floor(nr), p), F.cdata, zeros(m+2*mr, ceil(nr), p));
%       
%       % resize
%       OUTPUT_WIDTH = 896;
%       OUTPUT_HEIGHT = 448; % must be multiple of 16 for MPG4
%       [m, n, p] = size(F.cdata);
%       mratio = OUTPUT_HEIGHT/m;
%       nratio = OUTPUT_WIDTH/n;
%       if((mratio~=1)||(nratio~=1))
%         scale = min(mratio, nratio);
%         F.cdata = imresize(F.cdata, scale, 'bicubic');
%         [m, n, p] = size(F.cdata);
%         mpad = (OUTPUT_HEIGHT-m)/2;
%         npad = (OUTPUT_WIDTH-n)/2;
%         if(mpad)
%           F.cdata = cat(1, zeros(floor(mpad), OUTPUT_WIDTH, p), F.cdata, zeros(ceil(mpad), OUTPUT_WIDTH, p));
%         elseif(npad)
%           F.cdata = cat(2, zeros(OUTPUT_HEIGHT, floor(npad), p), F.cdata, zeros(OUTPUT_HEIGHT, ceil(npad), p));
%         end
%       end

      mov = addframe(mov, F);

      if(showImages)
        figure(1);
        cla;
        imshow(F.cdata);
      end
    end
  end
catch err
  fprintf('\n%s', err.message);
  fprintf('\nDone');
end
mov = close(mov);
