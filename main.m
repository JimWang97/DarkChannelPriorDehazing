clear all;
%%
%ѭ����ȡͼ��
for i=2:2
    clear I T  Alight darkchannel output output1 softmattingT;
    I=im2double(imread('1.JPG'));
    I = 1-I;
    [H,W,~] = size(I);
%%
%����A ��ͨ�� ��ԭʼ��T
    ALight = calcRowAirlight(I); %����A
    darkchannel=calcDarkChannel(I,7);%���㰵ͨ��
    T=1-0.95*darkchannel/min(ALight(1,:));%����ԭʼ��T
    output=defogging(I,ALight,T);%ԭʼTȥ��
    imshow(1-output);
 end