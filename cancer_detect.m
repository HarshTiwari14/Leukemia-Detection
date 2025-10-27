clc; close all; clear all;

I = imread('F2.jpg');
I = imresize(I,[200,300]);
figure; imshow(I); title('Original Image');

I_filt = imgaussfilt(I, 1.2);
I_enh = imadjust(I_filt,stretchlim(I_filt,[0.01 0.99]));
figure; imshow(I_enh); title('Enhanced Image (contrast improved)');

I_open = imopen(I_enh, strel('disk',2));
I_top = imtophat(I_open, strel('disk',10));
figure; imshow(I_top); title('Morphological Top-hat Filtered');

gray_image = rgb2gray(I_top);
gray_image = adapthisteq(gray_image);
figure; imshow(gray_image); title('Grayscale (Equalized)');

[centers, radii] = imfindcircles(gray_image,[2 80],'ObjectPolarity','dark','Sensitivity',0.92);
figure; imshow(I_enh); title('Detected Cells'); hold on;
h = viscircles(centers, radii, 'EdgeColor','b');

cell_count = length(centers);
meanR = mean(radii);
maxR = max(radii);
disp(['Total cells detected: ', num2str(cell_count)]);
disp(['Mean cell radius: ', num2str(meanR)]);
disp(['Maximum cell radius: ', num2str(maxR)]);

lab_img = rgb2lab(I_enh);
ab = double(lab_img(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

nColors = 3;
[cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean','Replicates',3);
pixel_labels = reshape(cluster_idx,nrows,ncols);

figure;
imshow(pixel_labels,[]); title('K-means Clustered Image');

segmented_cells = pixel_labels == mode(pixel_labels(:));
segmented_cells = imfill(segmented_cells,'holes');
segmented_cells = bwareaopen(segmented_cells,50);

figure; imshow(segmented_cells); title('Segmented Potential Cancer Cells');

seg_ref = imopen(segmented_cells, strel('disk',2));
seg_ref = imclose(seg_ref, strel('disk',3));
figure; imshow(seg_ref); title('Refined Segmentation');

[labeled, num_regions] = bwlabel(seg_ref, 4);
stats = regionprops(labeled,'Area','Perimeter','Eccentricity','Circularity');

areas = [stats.Area];
ecc = [stats.Eccentricity];
circ = [stats.Circularity];

avg_area = mean(areas);
avg_ecc = mean(ecc);
avg_circ = mean(circ);

disp('----- Feature Statistics -----');
fprintf('Average area: %.2f\n', avg_area);
fprintf('Average eccentricity: %.2f\n', avg_ecc);
fprintf('Average circularity: %.2f\n', avg_circ);

cancer_cells = num_regions;
cancer_ratio = (cancer_cells / cell_count) * 100;

disp('-------------------------------------');
disp(['Cancer (myeloid) cells detected: ', num2str(cancer_cells)]);
disp(['Myeloid cells percentage: ', num2str(cancer_ratio), '%']);
disp('-------------------------------------');

if cancer_ratio < 0.5
    stage = 'Healthy — No abnormality detected.';
elseif cancer_ratio < 2
    stage = 'High myeloid concentration (Monitor).';
elseif cancer_ratio < 8
    stage = 'Initial Stage Leukemia Detected.';
else
    stage = 'Advanced Stage Leukemia Detected!';
end

disp(['Diagnosis: ', stage]);

figure;
imshow(I_enh); hold on;
viscircles(centers, radii, 'EdgeColor','b');
visboundaries(seg_ref,'Color','r','LineWidth',1);
title(['Detected Cells: ', num2str(cell_count), ...
       ' | Cancer Cells: ', num2str(cancer_cells), ...
       ' | Myeloid %: ', num2str(round(cancer_ratio,2)), '%']);
annotation('textbox',[0.15,0.01,0.8,0.05],...
           'String',stage,'FitBoxToText','on','EdgeColor','none','FontSize',10,'Color','r');
