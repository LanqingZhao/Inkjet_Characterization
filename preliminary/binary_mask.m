function bin_image = binary_mask(image,is_d)
%% Step2: Generate binary mask
%This function takes a grayscale image and find the binary mask based on
%Otsu Method
%Input : original grayscale image
%Output: binary mask
level = graythresh(image);
bin_image = imbinarize(image,level);
if(is_d==1)
se = ones(12,12);
bin_image =logical(imdilate(bin_image,se));
elseif (is_d ==2)
    se = ones(2,2);
    bin_image = logical(imdilate(bin_image,se));
end
end
