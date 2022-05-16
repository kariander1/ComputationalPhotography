%%%
% WET 1
% Computational Photography WET 1
%
% Shai Yehezkel 205917883
% Lior Dvir     207334376
%%%
function est_x=deconvFreq(y,k,eta,sigma)
    mat_abs = @(a) conj(a).*a; % = |a|^2
    
    % Define image derivatives
    [m,n]   = size(y);
    gx      = [-1 1];
    gy      = gx.';    
    
    Gx      = sparse(fft2(gx,m,n));
    Gy      = sparse(fft2(gy,m,n));
    
    K       = sparse(fft2(k,m,n));
    
    % calc eps term of wiener filter
    epsilon = mat_abs(Gx) + mat_abs(Gy);
    
    % Calculate T & b components of wiener filter
    T_f     = (1/(2*eta^2)).*mat_abs(K) +(1/(2*sigma^2))*epsilon;
    b_f     = (1/(2*eta^2))*conj(K).*fft2(y);
    
    % Solve wiener filter in freq domain
    x_f     = b_f ./ T_f ;
    
    % Return from freq domain
    est_x   = ifft2(full(x_f));
    
    % shift image by half the dims of k since it was centerd in middle
    % coordinates (and not (0,0))
    x_shift = floor((size(k,1)-1)/2);
    y_shift = floor((size(k,2)-1)/2);
    est_x   = circshift(est_x,[x_shift , y_shift]);
end


