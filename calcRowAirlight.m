function ALight = calcRowAirlight(input)
%darkchannel = rand(100,100);
ALight=zeros(1,3);
[h, w, ~] = size(input);
%darkchannel = zeros(h, w);

pixeldc = min(input, [], 3);
darkchannel = pixeldc;
R=round(0.01.*min(h,w));

for i = R+1:h-R
   for j = R+1:w-R
      patch = pixeldc(i-R:i+R,j-R:j+R);
      darkchannel(i, j) = min(min(patch));
   end
end
N = round(h * w * 0.001); %用前0.1%个像素的平均值作为A
if N==0
    N=1;
end
D= sort(darkchannel(:),'descend');
B = D(N,1);
a=darkchannel>=B;
a1=input(:,:,1).*a;
a2=input(:,:,2).*a;
a3=input(:,:,3).*a;
ALight(1) = sum(sum(a1))/sum(sum(a));
ALight(2) = sum(sum(a2))/sum(sum(a));
ALight(3) = sum(sum(a3))/sum(sum(a));
end


