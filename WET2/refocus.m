function I=refocus(LF,s,mask)
%%%
% WET 2
% Computational Photography WET 1
%
% Shai Yehezkel 205917883
% Lior Dvir     207334376
%%%

lensletSize = 16;
maxUV = (lensletSize - 1) / 2;
u_new = (1:lensletSize) - 1 - maxUV;
v_new = (1:lensletSize) - 1 - maxUV;

LF_shifted = zeros(lensletSize, lensletSize,400, 700, 3);
for u = 1:lensletSize
    for v = 1:lensletSize
        I_r = squeeze(double(LF(u,v,:,:,1)));
        I_g = squeeze(double(LF(u,v,:,:,2)));
        I_b = squeeze(double(LF(u,v,:,:,3)));
        

        x_axis = (1:400) + s*u_new(u);
        y_axis = (1:700) + s*v_new(v);
        [xq,yq] = meshgrid(x_axis,y_axis);
        Iint_r = interp2(1:400,1:700,I_r.',xq,yq,'linear').';
        Iint_g = (interp2(1:400,1:700,I_g.',xq,yq,'linear').');
        Iint_b = (interp2(1:400,1:700,I_b.',xq,yq,'linear').');
        Iint_rgb = cat(3, Iint_r, Iint_g, Iint_b);
        LF_shifted(u,v,:,:,:) = Iint_rgb * mask(u,v);
    end
end

I = uint8(squeeze(sum(LF_shifted,[1 2])));

end