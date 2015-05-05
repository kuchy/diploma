function createSaliencyVideo(path, framerate)

outputVideo = VideoWriter(fullfile(path,'saliency_out.avi'));
outputVideo.FrameRate = framerate;
open(outputVideo);

imageNames = dir(fullfile(path,'*.jpg'));
imageNames = {imageNames.name}';

for ii = 1:length(imageNames)
   img = imread(fullfile(path,imageNames{ii}));   
   writeVideo(outputVideo,img)   
end

close(outputVideo)