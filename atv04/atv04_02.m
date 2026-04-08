% Thiago dos Santos Marcelino

clear; clc; close all;

img = imread("b5s.40.bmp");

img_sigma_1 = imgaussfilt(img, 1);
img_sigma_2 = imgaussfilt(img, 0.5);

figure;

subplot(1, 3, 1); imshow(img);          title('Original');
subplot(1, 3, 2); imshow(img_sigma_1);  title('Sigma 1');
subplot(1, 3, 3); imshow(img_sigma_2);  title('Sigma 0.5');
