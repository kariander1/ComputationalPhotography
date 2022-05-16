%%%
% WET 1
% Computational Photography WET 1
%
% Shai Yehezkel 205917883
% Lior Dvir     207334376
%%%
function est_x=deconvPrimal(y,k,eta,sigma,is_cyclic)

    mat_abs = @(a) a.'*a; % = |a|^2
    
    y       = sparse(y);
    k       = sparse(k);
    
    [m,n]   = size(y);
    
    % Define image derivatives
    gx      = [-1 1];
    gy      = gx.';
    
    % Get multiplication matrices of derivatives
    C_gx    = sparse(getConvMat(gx,m,n,is_cyclic));
    C_gy    = sparse(getConvMat(gy,m,n,is_cyclic));
    
    % Get multplication matrix of blur kernel 
    A       = sparse(getConvMat(k,m,n,is_cyclic));
    
    % Calculate T & b components of linear eq. system
    T       = (1/(2*(eta^2)))*mat_abs(A)+(1/(2*(sigma^2)))*(mat_abs(C_gx)+mat_abs(C_gy));
    b       = (1/(2*(eta^2)))*(A.'*y(:));
    
    % Solve linear eq. system with matlab \ operator
    est_x   = full(reshape(T\b,size(y)));
end