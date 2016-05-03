function [averageTime, maxTime, minTime, fps]=computeModel(folder, model)
modelFunction = str2func(model);

mapsSubdirectory = 'saliency';
mkdir(fullfile(folder,mapsSubdirectory,model));

% load all images from this folder (video)
imageNames = dir(fullfile(folder,'*.jpg'));
imageNames = {imageNames.name}';
evulationTimes= zeros(length(imageNames),1);

for ii = 1:length(imageNames)
    if (ii~=1)
        frameName = fullfile(folder,imageNames{ii-1});        
    else
        frameName = fullfile(folder,imageNames{1});
    end
    oldFrame = imread(frameName);
    frameName = fullfile(folder,imageNames{ii});
    img = imread(frameName);
    tic;
    switch nargin(modelFunction)
        case 1
            map = modelFunction(img);
        case 2
            map = modelFunction(img, oldFrame);
    end
    imwrite(map,fullfile(folder, mapsSubdirectory,model,imageNames{ii})); 
    time = toc;
    evulationTimes(ii) = time;
    disp(['current frame:',num2str(ii),' time: ', num2str(time)]);   
end

averageTimeNum = mean(evulationTimes);
averageTime = num2str(averageTimeNum);
maxTime = num2str(max(evulationTimes));
minTime = num2str(min(evulationTimes));
fps = 1/averageTimeNum;
disp(['average time of frame: ', averageTime]);
clear modelFunction;