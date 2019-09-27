clear all;
%%
%循环读取图像
for i=2:2
    clear I T  Alight darkchannel output output1 softmattingT;
    I=im2double(imread('1.JPG'));
    I = 1-I;
    [H,W,~] = size(I);
%%
%计算A 暗通道 和原始的T
    ALight = calcRowAirlight(I); %计算A
    darkchannel=calcDarkChannel(I,7);%计算暗通道
    T=1-0.95*darkchannel/min(ALight(1,:));%计算原始的T
    output=defogging(I,ALight,T);%原始T去雾
    imshow(1-output);
 end