% -----------------------------------------------------------------------------%
% database built in 2011 by Dr. Dubravko Culibrk and Dr. Matei Mancas          %
%                                                                              %
% comparison made in 2012 by Nicolas Riche during his PhD Thesis under the     %
% supervision of Dr. Matei Mancas                                              % 
%                                                                              %
% If you use this database please cite this paper :                            %
% -------------------------------------------------                            %
% N. RICHE, M. MANCAS, D. CULIBRK, V. CRNOJEVIC, B. GOSSELIN, T. DUTOIT, 2012, %
% "Dynamic saliency models and human attention: a comparative study on videos  %
% Proceedings of the 11th Asian Conference on Computer Vision (ACCV)           %
% Daejeon, Korea, November 5 - 9, 2012.                                        %
% -----------------------------------------------------------------------------%

clc
close all
clear all

% Here you can choice the video and frame
video=24;
frame=12;

% Video Reader
name=strcat('videos/video',num2str(video),'.wmv');
xyloObj = VideoReader(name);
nFrames = xyloObj.NumberOfFrames;
vidHeight = xyloObj.Height;
vidWidth = xyloObj.Width;
mov = read(xyloObj, frame);

% Raw Data Reader
filename=strcat('raw_data/raw_data_video',num2str(video),'.mat');
load(filename)
Image = RawData2Image(raw_data,frame,vidHeight, vidWidth);

% Preprocess for drawing
X = zeros(1,10); Y = zeros(1,10);
X(1,:) = raw_data(1,frame,:); Y(1,:) = raw_data(2,frame,:);

Iet = imfilter(imdilate(Image,strel('disk',20)),fspecial('gaussian',60,20),'replicate');
Iet = (Iet-min(Iet(:)))./(max(Iet(:))-min(Iet(:)));
level=0.7;
ET = im2bw(Iet,level);

I = cat(3,double(Iet),double(rgb2gray(mov)));
hm = sc(I,'prob_jet');

II = cat(3,double(ET),double(rgb2gray(mov)));
thm = sc(II,'prob_jet');

% Figure
figure;
subplot(2,2,1)
imshow(mov); title('Frame')
subplot(2,2,2)
imshow(mov); title('Frame with raw data')
hold on
plot(X,Y,'*')
subplot(2,2,3)
imshow(hm); title('Heat Map')
subplot(2,2,4)
imshow(thm); title('Thresholded Heat Map')
