function video(modelFunction)
modelFunction = str2func(modelFunction);
NumberFrameDisplayPerSecond=10;
 
hFigure=figure(1);
 
vid = videoinput('macvideo', 1);
set(vid,'FramesPerTrigger',1);
set(vid, 'ReturnedColorSpace', 'RGB');
set(vid,'TriggerRepeat',Inf);
triggerconfig(vid, 'Manual');
 
TimerData=timer('TimerFcn', {@compute,vid, modelFunction},'Period',1/NumberFrameDisplayPerSecond,'ExecutionMode','fixedRate','BusyMode','drop');
 
start(vid);
start(TimerData);
uiwait(hFigure);
 
% Clean up everything
stop(TimerData);
delete(TimerData);
stop(vid);
delete(vid);
% clear persistent variables
clear functions;
 
% This function is called by the timer to display one frame of the figure
 
function compute(obj, event,vid, modelFunction)
persistent IM;
persistent handlesRaw;
persistent handlesPlot;
persistent oldFrame;
persistent numOfCancelledFrames;
persistent oldMap;
trigger(vid);
IM=getdata(vid,1,'uint8');
 
if isempty(handlesRaw)
   subplot(2,1,1);
   handlesRaw=imagesc(IM);
   title('CurrentImage');
   oldFrame = IM;
 
   subplot(2,1,2);
   handlesPlot=imagesc(IM);
   title('CurrentImage');
   numOfCancelledFrames = 0;
else
   set(handlesRaw,'CData',IM);      
   if (numOfCancelledFrames==0)
       disp('computing');
       tic;
       switch nargin(modelFunction)
            case 1
                map = modelFunction(IM);
            case 2
                map = modelFunction(IM, oldFrame);
       end  
       frameTime = toc;
       idelFrateTime = 1/25;
       numOfCancelledFrames = round( frameTime / idelFrateTime);
       oldMap = map;
   else
       numOfCancelledFrames = numOfCancelledFrames-1;
       disp(numOfCancelledFrames);
   end   
   
   set(handlesPlot,'CData',oldMap);
   oldFrame = IM;
   
end