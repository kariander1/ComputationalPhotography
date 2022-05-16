function G=getConvMat(H,m,n,is_cyclic)
%getConvMat 2-D convolution matrix.
%   G=getConvMat(H,m,n,is_cyclic) returns the convolution matrix
%   for the filter matrix H, that can be used on a m-by-n matrix X.
%   If is_cyclic is true X is assumed to be cyclic, otherwise the
%   convolution is applied only to the valid region (without boundaries).
%   reshape(G*X(:), [m n]) is the same as conv2(X,H) on the valid region.
% 
H = fliplr(flipud(H));
filt = H;
h = m; w = n;
shifts = [];

  if (~exist('is_cyclic','var'))
    is_cyclic=0;
  end  
  if (isempty(shifts))
     [k1,k2]=size(filt);
     hk1d=floor(k1/2-0.5);
     hk2d=floor(k2/2-0.5);
     hk1u=k1-hk1d-1;
     hk2u=k2-hk2d-1;
     shifts=[-hk2d,hk2u,-hk1d,hk1u];
  end
  N=w*h;
  
  row_inds=zeros(1,N*prod(size(filt)));
  col_inds=row_inds;
  vals=row_inds;
  len=0;
  
  for j=1:w
    for i=1:h
      i;
      if (~is_cyclic)
        if ( ((i+shifts(3))<1)|((i+shifts(4))>h)|((j+shifts(1))<1)|((j+ ...
                                                            shifts(2))>w))
          continue
        end
      end
      for x=j+shifts(1):j+shifts(2)
        
        for y=i+shifts(3):i+shifts(4)
          %[x,y,j,i]
          len=len+1;
          xx=mod(x-1,w)+1;
          yy=mod(y-1,h)+1;
          row_inds(len)=i+(j-1)*h;
          col_inds(len)=yy+(xx-1)*h;
          vals(len)=filt(y-i-shifts(3)+1,x-j-shifts(1)+1);
        end  
      end
      
    end  
  end  
  
  G=sparse(row_inds(1:len),col_inds(1:len),vals(1:len),N,N);
