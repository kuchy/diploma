function result = findVideoByName(name, VideoData)

result = 'Not found';
for ii = 1:length(VideoData)
   if (VideoData(ii).name == name)
       result = VideoData(ii);
   end
end
