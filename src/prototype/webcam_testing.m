function webcam_testing(functionName)

% modelFunction = str2func(functionName);
% modelFunction = str2func('lucasKanade');
%   modelFunction = str2func('centerModel');
modelFunction = str2func('spectralResidual');

% Define frame rate
NumberFrameDisplayPerSecond=1;
 
% Open figure
hFigure=figure(1);
vid = videoinput('macvideo', 1, 'YCbCr422_1280x720');
set(vid, 'ReturnedColorSpace', 'RGB');
 
% Set parameters for video
% Acquire only one frame each time
set(vid,'FramesPerTrigger',1);
% Go on forever until stopped
set(vid,'TriggerRepeat',Inf);
% Get a grayscale image
triggerconfig(vid, 'Manual');
 
% set up timer object
TimerData=timer('TimerFcn', {@Compute,vid, modelFunction},'Period',1/NumberFrameDisplayPerSecond,'ExecutionMode','fixedRate','BusyMode','drop');
 
% Start video and timer object
start(vid);
start(TimerData);
 
% We go on until the figure is closed
uiwait(hFigure);
 
% Clean up everything
stop(TimerData);
delete(TimerData);
stop(vid);
delete(vid);
% clear persistent variables
clear functions;
 
% This function is called by the timer to display one frame of the figure
 
function Compute(obj, event,vid, modelFunction)
persistent IM;
persistent oldFrame;
persistent handlesRaw;
persistent handlesMap;

trigger(vid);
IM=getdata(vid);

 
if isempty(handlesRaw)
   % if first execution, we create the figure objects
   subplot(2,1,1);
   handlesRaw=imagesc(IM);
   title('CurrentImage');
   
   subplot(2,1,2);
   handlesMap=imagesc(IM);
else
   map=downsample(IM,2);
   switch nargin(modelFunction)
        case 1
            map = modelFunction(IM);
        case 2
            map = modelFunction(IM, oldFrame);
   end  
   set(handlesRaw,'CData',IM);
   set(handlesMap,'CData',IM);
%    oldFrame = IM;
end