files = dir('./gaze_data');
for i = 3:length(files)
    fileName = files(i).name;
    if (strcmp(fileName, '.') || strcmp(fileName, '..'))
        continue
    end
    array= strsplit(fileName,'_');
    videoName = strcat(array{1}, {'_'}, array{2},{'_'}, array{3});
    userName = array{4};
    
    VideoNameLeft = strcat(videoName(1), {'_left.avi'});
    VideoNameRight = strcat(videoName(1), {'_right.avi'});
    
    temp = load(fullfile('gaze_data',files(i).name));
    savam(i).name = videoName;
    savam(i).data = temp;
    
end

%     for each videonames
files = dir('./video/*.avi');
for i = 1:length(files)
    shuttleVideo = VideoReader(fullfile('video',files(i).name));
    video = read(shuttleVideo);
    nFrames = size(video,4);
    
%     create video object
    outputVideo = VideoWriter(fullfile('output',files(i).name));
    outputVideo.FrameRate = 25;
    open(outputVideo);
    
    startTime = 1000000000;
    endTime = startTime;
    oneFrame = 40000;
    index = 1;
    
%     get colors to every user
    colors = distinguishable_colors(size(savam,2));
    colors = colors * 255;
    
    for j = 1 : nFrames
       endTime = endTime + oneFrame;
       frame = video(:,:,:,j);
%        TODO find right data in structure and do multiuser
        for l=1 : size(savam,2)
%             TODO filter by name of video parametrize!
            if (~strcmp(savam(l).name,'v01_Hugo_2172'))
                continue;
            end
            data = savam(l).data;
            startIndex = index;
            
            for k = 1 : data                
                if (index>size(data,1))
                    break;
                end
                userData = data(index,:,:,:,:);
                if (userData(1,1,1,1,1)>endTime)
%             stop now
                    break;
                else
%                     add vizualization felt and right eye
        %           TODO maybe to only one eye per video?
                    frame = insertShape(frame, 'circle', [userData(2) userData(3) 10], 'LineWidth', 5,'Color',colors(l,:));
                    frame = insertShape(frame, 'circle', [userData(4) userData(5) 10], 'LineWidth', 5,'Color',colors(l,:));            
                end
                index =  index+1;
                if (index>size(data,1))
                    break;
                end                 
            end
%             dont set it on last user
            if (size(savam,2)~=l)
                index = startIndex;
            end
        end
        writeVideo(outputVideo,frame);
    end
    close(outputVideo)
        
end