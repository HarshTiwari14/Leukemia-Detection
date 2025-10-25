clc; close all; clear all;

I = imread('F2.jpg');
I = imresize(I,[200,300]);
figure; imshow(I); title('Original Image');

rgb = imopen(I, strel('disk',1));
figure; imshow(rgb); title('After Morphological Opening');

gray_image = rgb2gray(rgb);
figure; imshow(gray_image); title('Grayscale Image');

[centers, radii] = imfindcircles(rgb,[2 80],'ObjectPolarity','dark','Sensitivity',0.9);
figure; imshow(rgb); title('Detected Cells');
h = viscircles(centers, radii, 'EdgeColor','b');

cell = length(centers);
M = mean(radii);
maxR = max(radii);

disp(['Total cells detected: ', num2str(cell)]);
disp(['Mean cell radius: ', num2str(M)]);
disp(['Maximum cell radius: ', num2str(maxR)]);

red = rgb(:,:,1);
green = rgb(:,:,2);
blue = rgb(:,:,3);

out = red > 25 & red < 199 & green < 130 & blue > 140 & blue < 225;
out1 = imfill(out, 'holes');
out2 = bwmorph(out1, 'erode');
out3 = bwmorph(out2, 'dilate', 1.2);
out3 = imfill(out3, 'holes');
out3 = bwareaopen(out3, 100);

figure; imshow(out3); title('Segmented Cancer Cells');

out3 = im2bw(out3);
[l, NUM] = bwlabel(out3, 4);

disp(['Cancer (myeloid) cells detected: ', num2str(NUM)]);

cancer = (NUM / cell) * 100;

disp('-------------------------------------');
disp(['Myeloid cells percentage: ', num2str(cancer), '%']);
disp('-------------------------------------');

if cancer < 0.8
    disp('Result: Healthy. No Problem.');
elseif cancer < 1 && cancer > 0.5
    disp('Result: High myeloid cell concentration.');
elseif cancer > 1 && cancer < 8
    disp('Result: Initial Stage Leukemia.');
elseif cancer > 8
    disp('Result: Advanced Stage Leukemia.');
else
    disp('Result: Unable to determine accurately.');
end

figure;
imshow(rgb);
hold on;
viscircles(centers, radii, 'EdgeColor','b');
title(['Detected Cells: ', num2str(cell), ' | Cancer Cells: ', num2str(NUM), ...
       ' | Myeloid %: ', num2str(round(cancer,2)), '%']);
