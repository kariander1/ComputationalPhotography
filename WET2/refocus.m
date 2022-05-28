function I=refocus(LF,s,mask)
%%%
% WET 2
% Computational Photography WET 1
%
% Shai Yehezkel 205917883
% Lior Dvir     207334376
%%%

% Define lenslet size and coordinates as in hint
lensletSize = 16;
maxUV = (lensletSize - 1) / 2;
u_new = (1:lensletSize) - 1 - maxUV;
v_new = (1:lensletSize) - 1 - maxUV;

% Fetch dims of each image
height = size(LF,3);
width = size(LF,4);
LF_shifted = zeros(lensletSize, lensletSize,height, width, 3);

% Iterate for each lenslet
for u = 1:lensletSize
    for v = 1:lensletSize
        % Extact 3 channel images
        I_r = squeeze(double(LF(u,v,:,:,1)));
        I_g = squeeze(double(LF(u,v,:,:,2)));
        I_b = squeeze(double(LF(u,v,:,:,3)));
        
        % Create shifted axes b slope
        y_axis = (1:height) + s*u_new(u);
        x_axis = (1:width) + s*v_new(v);
        [xq,yq] = meshgrid(x_axis,y_axis);
        
        % Clip out-of-range indices
        xq = max(min(xq,width),1);
        yq = max(min(yq,height),1);
        
        % Interpolate each channel
        Iint_r = interp2(1:width,1:height,I_r,xq,yq);
        Iint_g = interp2(1:width,1:height,I_g,xq,yq);
        Iint_b = interp2(1:width,1:height,I_b,xq,yq);
        
        % Merge back into rgb image and apply mask
        Iint_rgb = cat(3, Iint_r, Iint_g, Iint_b);
        LF_shifted(u,v,:,:,:) = Iint_rgb * mask(u,v);
    end
end
% Convert to uint 8 image and sum lenslet dims
I = uint8(squeeze(sum(LF_shifted,[1 2])));

end