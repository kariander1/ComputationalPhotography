function [all_focus_I,depth_I]=refocusAll(focal_stack,s_arr)
%%%
% WET 2
% Computational Photography WET 1
%
% Shai Yehezkel 205917883
% Lior Dvir     207334376
%%%

focal_stack = double(focal_stack);
sigma1 = 0.1;
sigma2 = 0.1;
I_luminance = zeros(size(focal_stack,1),size(focal_stack,2),size(focal_stack,3));
I_low_freq  = zeros(size(I_luminance));
I_high_freq  = zeros(size(I_luminance));
w_sharpness  = zeros(size(I_luminance));
focus_nominator = zeros(size(focal_stack,2),size(focal_stack,3),3);
depth_nominator = zeros(size(focal_stack,2),size(focal_stack,3));
for i = 1:size(focal_stack,1)
    I_luminance(i,:,:) = rgb2gray(squeeze(focal_stack(i,:,:,:)));
    I_low_freq(i,:,:)  = imgaussfilt(I_luminance(i,:,:),sigma1);
    I_high_freq(i,:,:) = I_luminance(i,:,:) - I_low_freq(i,:,:);
    w_sharpness(i,:,:) = imgaussfilt((I_luminance(i,:,:)).^2,sigma2);
    focus_nominator    = focus_nominator + squeeze(w_sharpness(i,:,:)).*squeeze(focal_stack(i,:,:,:));
    depth_nominator    = depth_nominator+squeeze(w_sharpness(i,:,:)).*i;
end

weights     = squeeze(sum(w_sharpness,1));
all_focus_I = (focus_nominator./weights);
depth_I     = (depth_nominator./weights);

end