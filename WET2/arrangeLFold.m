function I=arrangeLFold(I,u_max,v_max)
%%%
% WET 2
% Computational Photography WET 1
%
% Shai Yehezkel 205917883
% Lior Dvir     207334376
%%%


% Load variable from data mat
figure();
subplot(1,2,1);
imshow(I);
I_orig = I;
%I = permute(I,[3 2 1]);
%I = I(:,:,2);

I_reshaped = reshape(I,[size(I_orig,3) 700 400 16 16 ]);
I_reshaped = permute(I_reshaped,[5 4 3 2 1]);
%I_reshaped = reshape(I,u_max ,v_max ,size(I,1)/u_max ,size(I,2)/v_max , size(I,3));
%I_reshaped = reshape(I,[6400/16 11200*16 size(I,3)]);

%subplot(1,2,2);
figure();
mat_ind = ((((0:16:11200-16)*6400).')+(1:16:6400)).';
%I_one = reshape(I(mat_ind(:)),[400 700]);
[m,n,c] = size(I);
imshow(I([1:u_max:m ((1:u_max:m)+1)],[1:v_max:n ((1:v_max:n)+1)],:));
imshow(squeeze(I_reshaped(1,1,:,:,:)));

lensletSize = 16;
maxUV = (lensletSize - 1) / 2;
u = (1:lensletSize) - 1 - maxUV;
v = (1:lensletSize) - 1 - maxUV;

end