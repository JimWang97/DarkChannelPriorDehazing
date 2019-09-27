function J=defogging(Img,A,T)
        J(:,:,1) = (Img(:,:,1) - A(1,1) * (1-T))./T;
        J(:,:,2) = (Img(:,:,2) - A(1,2) * (1-T))./T;
        J(:,:,3) = (Img(:,:,3) - A(1,3) * (1-T))./T;
