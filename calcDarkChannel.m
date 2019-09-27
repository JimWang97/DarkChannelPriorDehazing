function darkchannel = calcDarkChannel(input,r)
[h, w, ~] = size(input);
%zeros(height, width);
%radius = 5;%round(min(height, width) * 0.02);
pixeldc = min(input, [], 3);
darkchannel = pixeldc;
for i = r+1:h-r
   for j = r+1:w-r
      patch = pixeldc(i-r:i+r,j-r:j+r);
      darkchannel(i, j) = min(min(patch));    %取一个半径是r的块内最小值作为该点的暗通道
   end
end
end
