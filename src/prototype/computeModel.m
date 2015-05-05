function [averageTime, maxTime, minTime, fps]=computeModel(folder, model)
modelFunction = str2func(model);

mapsSubdirectory = 'saliency';
mkdir(fullfile(folder,mapsSubdirectory,model));

% load all images from this folder (video)
imageNames = dir(fullfile(folder,'*.jpg'));
imageNames = {imageNames.name}';
evulationTimes= zeros(length(imageNames),1);

for ii = 1:length(imageNames)
    frameName = fullfile(folder,imageNames{ii});
    img = imread(frameName);
    tic;
    map = modelFunction(img);
    time = toc;
    evulationTimes(ii) = time;
    imwrite(map,fullfile(folder, mapsSubdirectory,model,imageNames{ii})); 
    disp(['current frame:',num2str(ii),' time: ', num2str(time)]);
end
averageTimeNum = mean2(evulationTimes);
averageTime = num2str(averageTimeNum);
maxTime = num2str(max(evulationTimes));
minTime = num2str(min(evulationTimes));
fps = 1/averageTimeNum;
disp(['average time of frame: ', averageTime]);