function [all_focus_I,depth_I]=refocusAll(focal_stack,s_arr)
%%%
% WET 2
% Computational Photography WET 1
%
% Shai Yehezkel 205917883
% Lior Dvir     207334376
%%%

% Perform calculations on double types
focal_stack = double(focal_stack);

% Define STDs for Gassian Blur
sigma1 = 1;
sigma2 = 8;

% Define empty multi-D arrays
w_sharpness     = zeros(size(focal_stack,1),size(focal_stack,2),size(focal_stack,3));
focus_nominator = zeros(size(focal_stack,2),size(focal_stack,3),3);
depth_nominator = zeros(size(focal_stack,2),size(focal_stack,3));

% Foreach image in the focas stack perform
for i = 1:size(focal_stack,1)
    % Calclate luminance and low+high freq images
    I_luminance   = double(rgb2gray(uint8(squeeze(focal_stack(i,:,:,:)))));
    I_low_freq    = imgaussfilt(I_luminance,sigma1);
    I_high_freq   = I_luminance - I_low_freq;
    
    % Calculate image weights
    w_sharpness_temp   = imgaussfilt((I_high_freq).^2,sigma2);
    
    % Summation over num of images dimensions
    focus_nominator    = focus_nominator + w_sharpness_temp.*squeeze(focal_stack(i,:,:,:));
    depth_nominator    = depth_nominator+w_sharpness_temp.*abs(s_arr(i));
    
    w_sharpness(i,:,:) = w_sharpness_temp;
end

% Calculate total weights
weights     = squeeze(sum(w_sharpness,1));

% Calculate all focus and depth
all_focus_I = uint8(focus_nominator./weights);
depth_I     = (depth_nominator./weights);

% Create a uint8 image of depth for display
depth_I     = im2uint8(1-rescale(depth_I));
end