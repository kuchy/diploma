function createSaliencyVideo(path, framerate)

outputVideo = VideoWriter(fullfile(path,'shuttle_out.avi'));
outputVideo.FrameRate = framerate;
open(outputVideo);

imageNames = dir(fullfile(path,'*.jpg'));
imageNames = {imageNames.name}';

for ii = 1:length(imageNames)
   img = imread(fullfile(path,imageNames{ii}));
   writeVideo(outputVideo,img)
   disp(['current frame:',num2str(ii)]);
end

close(outputVideo)