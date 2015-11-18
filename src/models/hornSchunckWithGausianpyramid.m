function img= hornSchunck( CurrentFrame, PreviousFrame)

% reduce image by gausian pyramid
CurrentFrame = impyramid(CurrentFrame, 'reduce');
CurrentFrame = impyramid(CurrentFrame, 'reduce');
PreviousFrame = impyramid(PreviousFrame, 'reduce');
PreviousFrame = impyramid(PreviousFrame, 'reduce');

hsize=[5 5];
sigma=1;
h = fspecial('gaussian',hsize,sigma);
PreviousFrame= imfilter(rgb2gray(PreviousFrame),h,'replicate');
CurrentFrame=imfilter(rgb2gray(CurrentFrame),h,'replicate');
[height width]=size(PreviousFrame);

alpha=10;
% Number of iterations.
iterations=3;


TempU=zeros(height,width);
TempV=zeros(height,width);
Window=[1/12 1/6 1/12;1/6 0 1/6;1/12 1/6 1/12];

TempEx = conv2(double(CurrentFrame),double(0.25*[-1,1;-1,1]),'same') + conv2(double(PreviousFrame),double(0.25*[-1  1; -1  1]),'same');

TempEy= conv2(double(CurrentFrame), double(0.25*[-1,-1;1,1]),'same') + conv2(double(PreviousFrame),double(0.25*[-1  -1; 1  1]), 'same');

TempEt= conv2(double(CurrentFrame), double(0.25*ones(2)),'same') + conv2(double(PreviousFrame), double(-0.25*ones(2)),'same');

TempNormal=TempEt./sqrt(TempEy.^2+TempEx.^2);
TempNormal(isnan(TempNormal))=0;
TempNormal(isinf(TempNormal))=0;
% size(TempEx);
for i=iterations
    ubar=conv2(double(TempU),Window,'same');
    vbar=conv2(double(TempV),Window,'same');
    TempU= ubar - ( TempEx.* ( ( TempEx.* ubar ) + ( TempEy.* vbar ) + TempEt ) ) ./ ( alpha^2 + TempEx.^2 + TempEy.^2);
    TempV= vbar - ( TempEy.* ( ( TempEx.* ubar ) + ( TempEy.* vbar ) + TempEt ) ) ./ ( alpha^2 + TempEx.^2 + TempEy.^2);
end
% TODO BETTER
img = TempU + TempV;

% thresholding and normalize
 img = abs(img) > 0.2;

%  morf open image
se = strel('disk',5);
img = imopen(img,se);

cc = bwconncomp(img,8);
rp = regionprops(cc, 'Area', 'PixelIdxList','centroid','Extrema');

if (cc.NumObjects > 0)
    % Sorting by size, largest first
    [~, ind] = sort([rp.Area], 'descend');
    
%     TODO
%     get first and connect if too close?
%      coords = rp(1).Centroid;
end
