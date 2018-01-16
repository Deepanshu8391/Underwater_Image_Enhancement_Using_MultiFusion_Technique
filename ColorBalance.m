function outval = ColorBalance(im_org)
num = 255;

if ndims(im_org) == 3
    
    R = sum(sum(im_org(:,:,1)))
    G = sum(sum(im_org(:,:,2)))
    B = sum(sum(im_org(:,:,3)))
    Max = max([R, G, B])
    ratio = [Max / R, Max / G, Max / B]

    satLevel1 = 0.005 * ratio
    satLevel2 = 0.005 * ratio
    
    [m, n, p] = size(im_org);
    imRGB_orig = zeros(p, m * n);
    for i = 1 : p
        imRGB_orig(i, :) = reshape(double(im_org(:, :, i)), [1, m * n]);
    end
else
    
    satLevel1 = 0.001;
    satLevel2 = 0.005;
    [m, n] = size(im_org);
    p = 1;
    imRGB_orig = reshape(double(im_org), [1, m * n]);
end

% full width histogram method
% percentage of the image to saturate to black or white, tweakable param

imRGB = zeros(size(imRGB_orig));
for ch = 1 : p 
    q = [satLevel1(ch), 1 - satLevel2(ch)]
    tiles = quantile(imRGB_orig(ch, :), q)
    temp = imRGB_orig(ch, :);
    temp(find(temp < tiles(1))) = tiles(1);
    temp(find(temp > tiles(2))) = tiles(2);
    imRGB(ch, :) = temp;
    bottom = min(imRGB(ch, :)) 
    top = max(imRGB(ch, :))
    imRGB(ch, :) = (imRGB(ch, :) - bottom) * num / (top - bottom); 
end
if ndims(im_org) == 3
    outval = zeros(size(im_org));
    for i = 1 : p
        outval(:, :, i) = reshape(imRGB(i, :), [m, n]); 
    end
else
    outval = reshape(imRGB, [m, n]); 
end
outval = uint8(outval);
