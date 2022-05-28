function LF=arrangeLF(I,u_max,v_max)
%%%
% WET 2
% Computational Photography WET 2
%
% Shai Yehezkel 205917883
% Lior Dvir     207334376
%%%

% Fetch size
[m,n,~] = size(I);

% Split to R,G,B
planoptic_r = I(:,:,1);
planoptic_g = I(:,:,2);
planoptic_b = I(:,:,3);

% Create masks for lenslet split
lenslet_s = u_max*ones(1,m/u_max);
lenslet_t = v_max*ones(1,n/v_max);

% Split each channel to its lenslets
lenslet_cells_r = mat2cell(planoptic_r, lenslet_s, lenslet_t);
lenslet_cells_g = mat2cell(planoptic_g, lenslet_s, lenslet_t);
lenslet_cells_b = mat2cell(planoptic_b, lenslet_s, lenslet_t);

% Permute and create LF per channel
LF_r = cell2mat(permute(lenslet_cells_r,[3,4,1,2]));
LF_g = cell2mat(permute(lenslet_cells_g,[3,4,1,2]));
LF_b = cell2mat(permute(lenslet_cells_b,[3,4,1,2]));

% Concat back into RGB
LF = cat(5 , LF_r, LF_g, LF_b);


end