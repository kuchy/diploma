% Tilke Judd May 2011
% Baseline center model to compare saliency models against.

function map = centerModel(img)

% get the size of the input image
[h, w, c] = size(img);

% load the center gaussian
center = imread('center.jpg');

% resize the center image to the size of the imgfile
map = imresize(center, [h, w]);

