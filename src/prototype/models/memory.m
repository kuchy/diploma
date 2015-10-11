function map = memory(img,oldFrame)
persistent activeMemory;

model =  'spectralResidual';

% todo get some other function every time - some balance loader
modelFunction = str2func(model');
memoryRange= 24;

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
    



 

 
