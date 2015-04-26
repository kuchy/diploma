function videoData=loadVideo(FileName,PathName)
shuttleVideo = VideoReader(fullfile(PathName,FileName));

videoDir = fullfile('temp',FileName);
mkdir(videoDir)

ii = 1;
% TODO parametrize
maxFrames = 40;

while shuttleVideo.NumberOfFrames>=ii && maxFrames>=ii
   img = read(shuttleVideo,ii);
   filename = [sprintf('%03d',ii) '.jpg'];
   fullname = fullfile(videoDir,filename);
   imwrite(img,fullname);
   disp(['current frame:',num2str(ii)]);
   ii = ii+1;
end

videoData.frameRate = shuttleVideo.frameRate;
videoData.name = shuttleVideo.name;
videoData.path = shuttleVideo.path;