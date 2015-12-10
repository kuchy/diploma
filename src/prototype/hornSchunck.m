function img= hornSchunck( CurrentFrame, PreviousFrame)
debug= false;
% todo cache old image, dymamic reducing or keyframing
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

% thresholding
 img = abs(img) > 0.5;

cc = bwconncomp(img,8);
rp = regionprops(img, 'Area', 'PixelList','centroid','Extrema');

% if have some moving images
if (cc.NumObjects > 2)
    % Sorting by size, largest first
     [~, ind] = sort([rp.Area], 'descend');
     
     rp=rp(ind);
    try
%         Marge object with same vector and to close    
    % marge 2 biggest areas by convex hull
     y =[rp(1).PixelList(:,2);rp(2).PixelList(:,2)];
     x =[rp(1).PixelList(:,1);rp(2).PixelList(:,1)];
     k = convhull(x,y);
     x_hull = x(k);
     y_hull = y(k);
     mask = poly2mask(x_hull, y_hull, size(img,1),size(img,2));
     if (debug)
      figure;
      subplot(3,2,[2,4,6]), plot(x(k),y(k),'r-',x,y,'b*');
      subplot(3,2,1), imshow(img);
      subplot(3,2,3), imshow(mask);
      img = img + mask;
      subplot(3,2,5), imshow(img);
     else
      img = img + mask; 
     end
     
    catch
%         do nothing
    end
     
%      imshow(img)
%      hold on
%      plot(x, y, 'og')
%      plot(x_hull, y_hull, 'r', 'LineWidth', 4)
%      hold off
    
%     img = bwconvhull(img);
    
%     TODO
%     get first and connect if too close?
%      coords = rp(1).Centroid;
end
