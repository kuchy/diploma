function img= hornSchunckNew( CurrentFrameOrig, PreviousFrameOrig )

debug = false;

% detect if camera is static and use median filtration else use object flow
% estimation

%% Object flow estimation 
% % reduce image by gausian pyramid
CurrentFrameOrig = impyramid(CurrentFrameOrig, 'reduce');
CurrentFrameOrig = impyramid(CurrentFrameOrig, 'reduce');

hsize=[5 5];
sigma=1;
h = fspecial('gaussian',hsize,sigma);

persistent PreviousFrame;
if isempty(PreviousFrame)
    PreviousFrame = impyramid(PreviousFrameOrig, 'reduce');
    PreviousFrame = impyramid(PreviousFrame, 'reduce');
    PreviousFrame= imfilter(rgb2gray(PreviousFrame),h,'replicate');
end
CurrentFrame=imfilter(rgb2gray(CurrentFrameOrig),h,'replicate');
[height, width]=size(PreviousFrame);


alpha=10;
% Number of iterations.
iterations=3;

TempU=zeros(height,width);
TempV=zeros(height,width);
Window=[1/12 1/6 1/12;1/6 0 1/6;1/12 1/6 1/12];

TempEx = conv2(double(CurrentFrame),double(0.25*[-1,1;-1,1]),'same') + conv2(double(PreviousFrame),double(0.25*[-1  1; -1  1]),'same');

TempEy= conv2(double(CurrentFrame), double(0.25*[-1,-1;1,1]),'same') + conv2(double(PreviousFrame),double(0.25*[-1  -1; 1  1]), 'same');

TempEt= conv2(double(CurrentFrame), double(0.25*ones(2)),'same') + conv2(double(PreviousFrame), double(-0.25*ones(2)),'same');

for i=iterations
    ubar=conv2(double(TempU),Window,'same');
    vbar=conv2(double(TempV),Window,'same');
    TempU= ubar - ( TempEx.* ( ( TempEx.* ubar ) + ( TempEy.* vbar ) + TempEt ) ) ./ ( alpha^2 + TempEx.^2 + TempEy.^2);
    TempV= vbar - ( TempEy.* ( ( TempEx.* ubar ) + ( TempEy.* vbar ) + TempEt ) ) ./ ( alpha^2 + TempEx.^2 + TempEy.^2);
end
% TODO BETTER preserve v and u
img = TempU + TempV;

persistent TTL;
persistent memory;
memoryRange = 24;
persistent frameNumber;
if isempty(TTL)
    TTL=ones(size(img));
    frameNumber = 0;    
end

%% Marging regions by velocity && distance
objectFlowThreshold = 0.2;

% thresholding for regioprops
img = abs(img) > objectFlowThreshold;

cc = bwconncomp(img,8);
rp = regionprops(img, 'Area', 'PixelList','centroid','Extrema', 'PixelIdxList');

% if have some moving regions
if (cc.NumObjects > 2)
    % Sorting by size, largest first
%      [~, ind] = sort([rp.Area], 'descend');
%      rp=rp(ind);
%     try
%         finding shifting by region
        horizontalAverage = zeros(cc.NumObjects,1);
        verticalAverage = zeros(cc.NumObjects,1);
        
        for regionIndex=1:cc.NumObjects             
            horizontalAverage(regionIndex) = max(TempV(rp(regionIndex).PixelIdxList));
            verticalAverage(regionIndex) = max(TempU(rp(regionIndex).PixelIdxList));
        end
        
%         create coocurrance matrix of distance of regions
        distanceAverage = zeros(cc.NumObjects,cc.NumObjects);
        for regionIndexOne=1:cc.NumObjects
            for regionIndexTwo=round(cc.NumObjects/2)+1:-1:(regionIndexOne+1)
               extrema1 = rp(regionIndexOne).Extrema;
               extrema2 = rp(regionIndexTwo).Extrema;              
%              calculate distance
               min = 999999999999;
               for j=1:8
                   corner1 = extrema1(j,:);
                   for k=1:8
                       corner2 = extrema2(k,:);
                       distance = sqrt( (corner2(1,1)-corner1(1,1))^2 + (corner2(1,2)-corner1(1,2))^2 );                       
                       if distance<min
                           min = distance;
                       end
                   end
               end
              
             distanceAverage(regionIndexOne, regionIndexTwo) = min;
             distanceAverage(regionIndexTwo, regionIndexOne) = min;                
            end
        end       
        img = mat2gray(img);
        
%         constants
        velocityTreshold = 0.1;
        distanceTreshold = 10;
        
%       Marge all regions with save directions and
        for regionIndexOne=1:cc.NumObjects
            for regionIndexTwo=regionIndexOne+1:1:cc.NumObjects
                horizontalCondition = abs(horizontalAverage(regionIndexOne) - horizontalAverage(regionIndexTwo)) < velocityTreshold;
                verticalCondition = abs(verticalAverage(regionIndexOne) - verticalAverage(regionIndexTwo)) < velocityTreshold;
                positionCondition = distanceAverage(regionIndexOne,regionIndexTwo) < distanceTreshold;
                if (verticalCondition && horizontalCondition && positionCondition)
                    if debug
                        disp(strcat(int2str(regionIndexOne), '-margeWith-',int2str(regionIndexTwo)));
                    end
                    y =[rp(regionIndexOne).PixelList(:,2);rp(regionIndexTwo).PixelList(:,2)];
                    x =[rp(regionIndexOne).PixelList(:,1);rp(regionIndexTwo).PixelList(:,1)];
                    
%                   too few points to calculate convex hull
                    if size(unique(y),1) < 3 || size(unique(x),1) < 3
                        continue;
                    end                   
                    
                    try
                        k = convhull(x,y);
                        x_hull = x(k);
                        y_hull = y(k);
                        mask = poly2mask(x_hull, y_hull, size(img,1),size(img,2));
                        img = img + mask;
                    catch
                        if debug
                            disp('colinear points');
                        end
                    end 
                end
            end
        end    
    
%   treshold matrix
    img = img > 0;
    
    % apply ttl matrix
    img = img .* TTL;

%   calculate coeficients
    memoryCoeficient = 0.2;

    if size(memory,2)>=20
        TTL = ones(size(img));
        for ii = 1:size(memory,2)
            TTL = TTL - (memory{ii}/size(memory,2))*memoryCoeficient;
        end
    end
    
    
%   TODO: 24frames memory
    modFrame = mod(frameNumber, memoryRange)+1;
    memory{modFrame} = img;
    frameNumber = frameNumber + 1;
    
%   Apply gausian filter
    hsize=[10 10];
    sigma=1;
    h = fspecial('gaussian',hsize,sigma);
    
    img = imfilter(img, h);
    PreviousFrame = CurrentFrame;
    
    staticFeatures = spectralResidual(CurrentFrameOrig);
    percentage = ((sum(img(:) > 0))/numel(img));
    
    img = (img .* (1-percentage)) + (staticFeatures .* percentage);
    disp(percentage);
end
