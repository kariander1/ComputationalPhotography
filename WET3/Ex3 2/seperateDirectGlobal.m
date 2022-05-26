function [Id,Ig]=seperateDirectGlobal(dirname)
%%%
% WET 3
% Computational Photography WET 3
%
% Shai Yehezkel 205917883
% Lior Dvir     207334376
%%%

% add all jpg files to dir path
scene_path = dirname + "/*.jpg";

% load all images in folder into image data storage
scene = imageDatastore(scene_path);

% load image into cell array
img = readall(scene);

% get size of image
img_size = size(cell2mat(img(1)));

% change cell array to array
img = cell2mat(permute(img, [3, 2, 1]));

% get number of images
num_of_images = size(img, 3) / img_size(3);

% reshape to fit images dimensions
img = reshape(img, [img_size num_of_images]);

% permute dimensions 
img = permute(img, [4, 1, 2, 3]);

% get global component
Ig = squeeze(min(img, [], 1));

% get direct + global component
Id_and_Ig = squeeze(max(img, [], 1));

% get direct component
Id = Id_and_Ig - Ig;