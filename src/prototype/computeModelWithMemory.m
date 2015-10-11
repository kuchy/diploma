function [averageTime, maxTime, minTime, fps]=computeModel(folder, model)
modelFunction = str2func(model);

mapsSubdirectory = 'saliency';
mkdir(fullfile(folder,mapsSubdirectory,model));

% load all images from this folder (video)
imageNames = dir(fullfile(folder,'*.jpg'));
imageNames = {imageNames.name}';
evulationTimes= zeros(length(imageNames),1);

% Parameters
modelFunction = str2func(model');
memoryRange = 24;
activeMemory = {};

for ii = 2:length(imageNames)
    frameName = fullfile(folder,imageNames{ii-1});
    oldFrame = imread(frameName);
    frameName = fullfile(folder,imageNames{ii});
    img = imread(frameName);
    tic;
    switch nargin(modelFunction)
        case 1
            aktualFrame = modelFunction(img);
        case 2
            aktualFrame = modelFunction(img, oldFrame);
    end
    
    % regenerate aktual map
    if (size(activeMemory,1) ~= 0)
        % parametrize memory size
        modFrame = size(activeMemory,2);
        modFrame = mod(modFrame, memoryRange)+1;
        activeMemory{modFrame} = aktualFrame;
        map = mean(cat(3,activeMemory{:}),3);
    else
        activeMemory{1} = aktualFrame;
        map = aktualFrame;
    end

    imwrite(map,fullfile(folder, mapsSubdirectory,model,imageNames{ii})); 
    time = toc;
    evulationTimes(ii) = time;
    disp(['current frame:',num2str(ii),' time: ', num2str(time)]);   
end

averageTimeNum = mean2(evulationTimes);
averageTime = num2str(averageTimeNum);
maxTime = num2str(max(evulationTimes));
minTime = num2str(min(evulationTimes));
fps = 1/averageTimeNum;
disp(['average time of frame: ', averageTime]);