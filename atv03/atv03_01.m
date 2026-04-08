% Thiago dos Santos Marcelino

clear; clc; close all;

img = imread('vpfig.png');

slopes = [0.02, 0.05, 0.15, 0.5];
inflec = 127;
x = 0:1:255;

figure;

for k = 1:4
    slope = slopes(k);

    y = 1./(1 + exp(-slope*(x - inflec)));
    
    lut = uint8(mat2gray(y) .* 255);
    
    img_out = intlut(img, lut);
    

    subplot(2, 2, k);
    imshow(img_out);
    title(sprintf('slope = %.2f', slopes(k)));
end
