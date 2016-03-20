    function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
    
% Edit the above text to modify the response to help main

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% loading generated videos
% tempFiles = dir(fullfile('temp'));
% tempFiles = {tempFiles(4:end).name}';

% add to path models folder
addpath(genpath('models'));

% add to path metrics folder
addpath(genpath('metrics'));

addpath(genpath('datasets'));

%inicialize table
data=get(handles.uitable1, 'data');

% loading models
modelFiles = dir(fullfile('models','*.m'));
modelFiles = {modelFiles.name}';

for ii = 1:length(modelFiles)
    path = fullfile('models',modelFiles{ii});
    [pathstr,name,ext] = fileparts(path);
    modelFiles{ii} = name;
    data(ii,1)={name};
end
set(handles.listbox1, 'String', modelFiles);


set(handles.uitable1, 'data', data);

% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName]=uigetfile('*.*','All Files');
LoadedData = loadVideo(FileName,PathName);

videoData = get(handles.pushbutton1,'UserData');
videoData = [videoData, LoadedData];

set(handles.pushbutton1,'UserData', videoData);
% refresh list of loaded videos
set(handles.listbox2, 'String', refreshList(get(handles.pushbutton1,'UserData')));

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index=get(handles.listbox2,'value');
list=get(handles.listbox2,'string');
video = cellstr(list(index));
name = video{1};

videoData = get(handles.pushbutton1,'UserData');
data = findVideoByName(name, videoData);

index=get(handles.listbox1,'value');
list=get(handles.listbox1,'string');
modelName = cellstr(list(index));

createSaliencyVideo(fullfile('temp',data.name,'saliency',modelName{1}), data.frameRate);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles) 
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)  
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index=get(handles.listbox1,'value');
list=get(handles.listbox1,'string');
functionName = cellstr(list(index));

index=get(handles.listbox2,'value');
list=get(handles.listbox2,'string');
name = cellstr(list(index));
name = name{1}; 

videoData = get(handles.pushbutton1,'UserData');
data = findVideoByName(name, videoData);

tableData=get(handles.uitable1, 'data');

% compute maps
[avgtime, max, min, fps] = computeModel(fullfile('temp',data.name), functionName{1});

for ii = 1:length(tableData)
    rowName = tableData(ii,1);
    if strcmp(rowName{1}, functionName{1})
        tableData(ii,2) = {avgtime};
        tableData(ii,3) = {max};
        tableData(ii,4) = {min};
        tableData(ii,5) = {fps};
    end
end

set(handles.uitable1, 'data', tableData);

% save video
createSaliencyVideo(fullfile('temp',data.name,'saliency',functionName{1}), data.frameRate);


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
videoData = get(handles.pushbutton1,'UserData');

index=get(handles.listbox2,'value');
list=get(handles.listbox2,'string');
video = cellstr(list(index));
name = video{1};

data = findVideoByName(name, videoData);

videoPath = fullfile(data.path,data.name);
saliencyPath = fullfile('temp',data.name,'saliency');


play(videoPath, saliencyPath);


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% cleanup temporary data after exit
system('rm -rf temp/*');


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on pushbutton7 and none of its controls.
function pushbutton7_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
index=get(handles.listbox1,'value');
list=get(handles.listbox1,'string');
functionName = cellstr(list(index));
video(functionName{1});
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on pushbutton8 and none of its controls.
function pushbutton8_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton8.
function pushbutton8_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index=get(handles.listbox1,'value');
list=get(handles.listbox1,'string');
functionName = cellstr(list(index));

index=get(handles.listbox2,'value');
list=get(handles.listbox2,'string');
name = cellstr(list(index));
name = name{1}; 

videoData = get(handles.pushbutton1,'UserData');
data = findVideoByName(name, videoData);

tableData=get(handles.uitable1, 'data');

% compute maps
[avgtime, max, min, fps] = computeModelWithMemory(fullfile('temp',data.name), functionName{1});

for ii = 1:length(tableData)
    rowName = tableData(ii,1);
    if strcmp(rowName{1}, functionName{1})
        tableData(ii,2) = {avgtime};
        tableData(ii,3) = {max};
        tableData(ii,4) = {min};
        tableData(ii,5) = {fps};
    end
end

set(handles.uitable1, 'data', tableData);


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index=get(handles.listbox3,'value');
list=get(handles.listbox3,'string');
databaseName = cellstr(list(index));

index=get(handles.listbox1,'value');
list=get(handles.listbox1,'string');
functionName = cellstr(list(index));


if strcmp(databaseName, 'ACCV2012_database')
    disp(strcat('Evaluation of: ',functionName{1}, ' on ',databaseName{1})); 
    Evaluation(functionName{1});
end

% % SAVAM
% videoData = get(handles.pushbutton1,'UserData');
% 
% index=get(handles.listbox2,'value');
% list=get(handles.listbox2,'string');
% video = cellstr(list(index));
% name = video{1};
% 
% data = findVideoByName(name, videoData);
% index=get(handles.listbox1,'value');
% list=get(handles.listbox1,'string');
% functionName = cellstr(list(index));
% 
% % TODO parametrize the frame number
% saliencyPath = fullfile('temp',data.name,'saliency', functionName{1},'005.jpg');
% saliencyMap = imread(saliencyPath);
% video = VideoReader('/Users/kuchy/skola/diplomovka/src/prototype/datasets/savam/video/v04_LIVE1_0_left_gt.avi');
% fixationMap = video.read(5);
% % fixationMap = loader('v04_LIVE1_0');
% % fixations = load('/Users/kuchy/skola/diplomovka/src/prototype/datasets/coutrot_database1.mat');
% fixationMap=rgb2gray(fixationMap);
% % figure; imshow(saliencyMap);
% % figure; imshow(fixationMap);
% saliencyMap = impyramid(saliencyMap, 'reduce');
% saliencyMap = impyramid(saliencyMap, 'reduce');
% fixationMap = impyramid(fixationMap, 'reduce');
% fixationMap = impyramid(fixationMap, 'reduce');
% AUC_Judd(saliencyMap, fixationMap, 0, 1)


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on pushbutton12 and none of its controls.
function pushbutton12_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on pushbutton11 and none of its controls.
function pushbutton11_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
