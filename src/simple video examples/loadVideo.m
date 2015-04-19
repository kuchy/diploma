videoDir = 'images';
mkdir(videoDir)

shuttleVideo = VideoReader('../../sorces/RSD_Dataset/VideoFixed/171.mp4');

ii = 1;

while shuttleVideo.NumberOfFrames>=ii
   img = read(shuttleVideo,ii);
   filename = [sprintf('%03d',ii) '.jpg'];
   fullname = fullfile(videoDir,filename);
   imwrite(img,fullname);
   disp('current frame:',ii);
   ii = ii+1;   
end

