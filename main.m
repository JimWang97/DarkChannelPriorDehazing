clear all;
%%
%ѭ����ȡͼ��

clear I T  Alight darkchannel output output1 softmattingT;
I=im2double(imread('input.bmp'));
[H,W,~] = size(I);
% % %%
%����A ��ͨ�� ��ԭʼ��T
ALight = calcRowAirlight(I); %����A
darkchannel=calcDarkChannel(I,7);%���㰵ͨ��
T=1-0.95*darkchannel/min(ALight(1,:));%����ԭʼ��T
output=defogging(I,ALight,T);%ԭʼTȥ��
imshow(output);
imwrite(output, 'output.bmp');