videoDir = 'images';

outputVideo = VideoWriter(fullfile(videoDir,'shuttle_out.avi'));
outputVideo.FrameRate = 29.9349;
open(outputVideo);

imageNames = dir(fullfile('images','*.jpg'));
imageNames = {imageNames.name}';

for ii = 1:length(imageNames)
   img = imread(fullfile('images',imageNames{ii}));
   writeVideo(outputVideo,img)
   disp('current frame:',ii);
end

close(outputVideo)