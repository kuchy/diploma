function play (videoPath, saliencyPath)
v1 = VideoReader(videoPath);

videos = rdir(fullfile(saliencyPath,'**','*.avi'));
numberOfVideos = size(videos,1);

for ii = 1:numberOfVideos
    salVideo(ii) = VideoReader(videos(ii).name);
    pathToVideo = strsplit(salVideo(ii).path,'/');
    
%     model is placed in directory with its name.
    modelName{ii} = pathToVideo{end};
end

hFig = figure(1);
set(hFig, 'Position', [0 0 1024 1024])

btn = uicontrol('Style', 'pushbutton', 'String', 'Save',...
        'Position', [20 20 50 20],...
        'Callback', 'saveScreenshot'); 

i1 = 0;

while i1 < v1.NumberOfFrames && i1 < salVideo(1).NumberOfFrames
    
%     ogirinal video
    if i1 < v1.NumberOfFrames
        i1 = i1+1;
        subplot(1,(numberOfVideos+1),1)
        image(v1.read(i1))
        text(-5,-5,'Original video');
    end

%     all created saliency videos
    for ii = 1:numberOfVideos
        v2 = salVideo(ii);
        if i1 < v2.NumberOfFrames             
            subplot(1,(numberOfVideos+1),(ii+1))
            image(v2.read(i1))
            text(-5,-5,['Model: ',modelName{ii}]);
        end
    end

    drawnow       
end
