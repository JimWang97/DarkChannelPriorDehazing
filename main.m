clear all;
%%
%循环读取图像

clear I T  Alight darkchannel output output1 softmattingT;
I=im2double(imread('input.bmp'));
[H,W,~] = size(I);
% % %%
%计算A 暗通道 和原始的T
ALight = calcRowAirlight(I); %计算A
darkchannel=calcDarkChannel(I,7);%计算暗通道
T=1-0.95*darkchannel/min(ALight(1,:));%计算原始的T
output=defogging(I,ALight,T);%原始T去雾
imshow(output);
imwrite(output, 'output.bmp');