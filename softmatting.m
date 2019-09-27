function alpha=softmatting(I,win_dark,h,w,win_size)
c=3;
img_size=h*w;
  for i=1:img_size
   win_dark(i)=1-win_dark(i);
 end
 
win_b = zeros(img_size,1);
%寻找每一个块的中心 15*15一个块 找中心8，8 23，23
for ci=1:h
    for cj=1:w
        if(rem(ci-8,15)<1) %整除求余
            if(rem(cj-8,15)<1)
                win_b(ci*w+cj)=win_dark(ci*w+cj);
            end
        end
       
    end
end
 

neb_size = (win_size*2+1)^2;
%指定矩阵形状
indsM=reshape([1:img_size],h,w);%建立一个h*w的矩阵 每一个位置对应序号 从1到h*w 按照列排序
%计算矩阵L
tlen = img_size*neb_size^2;
row_inds=zeros(tlen ,1);
col_inds=zeros(tlen,1);
vals=zeros(tlen,1);
len=0;
%寻找中心点 如果是就进行操作 否则继续找
for j=1+win_size:w-win_size
    for i=win_size+1:h-win_size
        if(rem(ci-8,15)<1)
            if(rem(cj-8,15)<1)
                continue;
            end
        end
      win_inds=indsM(i-win_size:i+win_size,j-win_size:j+win_size);
      win_inds=win_inds(:);%变成一列
      winI=I(i-win_size:i+win_size,j-win_size:j+win_size,:);%一个3*3的块并且是一个三通道的含有RGB
      winI=reshape(winI,neb_size,c); %三个通道被拉平成为一个二维矩阵 9*3
      win_mu=mean(winI,1)';  %求每一列的均值  //矩阵变向量
      win_var=inv(winI'*winI/neb_size-win_mu*win_mu' +0.0000001/neb_size*eye(c)); %求方差
      winI=winI-repmat(win_mu',neb_size,1);%求离差
      tvals=(1+winI*win_var*winI')/neb_size;% 求论文所指的矩阵L 这是L的计算公式 论文里有
      row_inds(1+len:neb_size^2+len)=reshape(repmat(win_inds,1,neb_size),neb_size^2,1); %记录下横坐标 一行
      col_inds(1+len:neb_size^2+len)=reshape(repmat(win_inds',neb_size,1),neb_size^2,1); %记录下纵坐标 一列
      vals(1+len:neb_size^2+len)=tvals(:); %保存矩阵L
      len=len+neb_size^2;
    end
end 
D=spdiags(win_b(:),0,img_size,img_size); 
 
vals=vals(1:len);
row_inds=row_inds(1:len);
col_inds=col_inds(1:len);
%创建稀疏矩阵
A=sparse(row_inds,col_inds,vals,img_size,img_size);
%求行的总和 sumA为列向量
sumA=sum(A,2);
A=spdiags(sumA(:),0,img_size,img_size)-A;
  %创建稀疏矩阵

  lambda=1;
  x=(A+lambda*D)\(lambda*win_b(:).*win_b(:)); %求解最优的公式win_b(:)为一个向量
 %http://blog.sina.com.cn/s/blog_67d185b801017auu.html
   %去掉0-1范围以外的数
  alpha=max(min(reshape(x,h,w),1),0);