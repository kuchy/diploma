video = VideoReader('0001-0233.avi');
% video = VideoReader('171.avi');
% get data about loaded video
vidHeight = video.Height;
vidWidth = video.Width;
get(video);
s= read(video, 10);
imshow(s);