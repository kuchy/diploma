function tempFiles = refreshList(videoData)
ii=1;
tempFiles={};
for ii = 1:length(videoData)
    if (isempty(tempFiles))        
        tempFiles{1} = videoData(ii).name;
    else
        tempFiles{end+1}=videoData(ii).name;
    end
end
tempFiles = tempFiles';
