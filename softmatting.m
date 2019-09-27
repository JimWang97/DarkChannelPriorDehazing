function alpha=softmatting(I,win_dark,h,w,win_size)
c=3;
img_size=h*w;
  for i=1:img_size
   win_dark(i)=1-win_dark(i);
 end
 
win_b = zeros(img_size,1);
%Ѱ��ÿһ��������� 15*15һ���� ������8��8 23��23
for ci=1:h
    for cj=1:w
        if(rem(ci-8,15)<1) %��������
            if(rem(cj-8,15)<1)
                win_b(ci*w+cj)=win_dark(ci*w+cj);
            end
        end
       
    end
end
 

neb_size = (win_size*2+1)^2;
%ָ��������״
indsM=reshape([1:img_size],h,w);%����һ��h*w�ľ��� ÿһ��λ�ö�Ӧ��� ��1��h*w ����������
%�������L
tlen = img_size*neb_size^2;
row_inds=zeros(tlen ,1);
col_inds=zeros(tlen,1);
vals=zeros(tlen,1);
len=0;
%Ѱ�����ĵ� ����Ǿͽ��в��� ���������
for j=1+win_size:w-win_size
    for i=win_size+1:h-win_size
        if(rem(ci-8,15)<1)
            if(rem(cj-8,15)<1)
                continue;
            end
        end
      win_inds=indsM(i-win_size:i+win_size,j-win_size:j+win_size);
      win_inds=win_inds(:);%���һ��
      winI=I(i-win_size:i+win_size,j-win_size:j+win_size,:);%һ��3*3�Ŀ鲢����һ����ͨ���ĺ���RGB
      winI=reshape(winI,neb_size,c); %����ͨ������ƽ��Ϊһ����ά���� 9*3
      win_mu=mean(winI,1)';  %��ÿһ�еľ�ֵ  //���������
      win_var=inv(winI'*winI/neb_size-win_mu*win_mu' +0.0000001/neb_size*eye(c)); %�󷽲�
      winI=winI-repmat(win_mu',neb_size,1);%�����
      tvals=(1+winI*win_var*winI')/neb_size;% ��������ָ�ľ���L ����L�ļ��㹫ʽ ��������
      row_inds(1+len:neb_size^2+len)=reshape(repmat(win_inds,1,neb_size),neb_size^2,1); %��¼�º����� һ��
      col_inds(1+len:neb_size^2+len)=reshape(repmat(win_inds',neb_size,1),neb_size^2,1); %��¼�������� һ��
      vals(1+len:neb_size^2+len)=tvals(:); %�������L
      len=len+neb_size^2;
    end
end 
D=spdiags(win_b(:),0,img_size,img_size); 
 
vals=vals(1:len);
row_inds=row_inds(1:len);
col_inds=col_inds(1:len);
%����ϡ�����
A=sparse(row_inds,col_inds,vals,img_size,img_size);
%���е��ܺ� sumAΪ������
sumA=sum(A,2);
A=spdiags(sumA(:),0,img_size,img_size)-A;
  %����ϡ�����

  lambda=1;
  x=(A+lambda*D)\(lambda*win_b(:).*win_b(:)); %������ŵĹ�ʽwin_b(:)Ϊһ������
 %http://blog.sina.com.cn/s/blog_67d185b801017auu.html
   %ȥ��0-1��Χ�������
  alpha=max(min(reshape(x,h,w),1),0);