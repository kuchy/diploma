function [map]=computeModel(folder, model)
modelFunction = str2func(model);

mapsSubdirectory = 'saliency';
mkdir(fullfile(folder,mapsSubdirectory));

% load all images from this folder (video)
imageNames = dir(fullfile(folder,'*.jpg'));
imageNames = {imageNames.name}';

for ii = 1:length(imageNames)
    disp(['current frame:',num2str(ii)]);
    frameName = fullfile(folder,imageNames{ii});
    img = imread(frameName);
    map = modelFunction(img);
    imwrite(map,fullfile(folder, mapsSubdirectory,imageNames{ii}));    
end
map = fullfile(folder, mapsSubdirectory);