function [path]=loadVideo(FileName,PathName)
shuttleVideo = VideoReader(fullfile(PathName,FileName));

videoDir = fullfile('temp',FileName);
mkdir(videoDir)

ii = 1;
% TODO parametrize
maxFrames = 5;

while shuttleVideo.NumberOfFrames>=ii && maxFrames>=ii
   img = read(shuttleVideo,ii);
   filename = [sprintf('%03d',ii) '.jpg'];
   fullname = fullfile(videoDir,filename);
   imwrite(img,fullname);
   disp(['current frame:',num2str(ii)]);
   ii = ii+1;   
end
path = videoDir;