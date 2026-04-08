% Thiago dos Santos Marcelino

clear; clc; close all;

img = imread("salt-and-pepper1.tif");

sz = 3;
half = floor(sz / 2);

[x, y] = size(img);

output = zeros(x, y, 'uint8');

for i = (half + 1):(x - half)
    for j = (half + 1):(y - half)
        region = img(i-half:i+half, j-half:j+half);
        output(i,j) = median(region(:));
    end
end

figure;

subplot(1, 2, 1); imshow(img);      title("Original");
subplot(1, 2, 2); imshow(output);   title("Filtro da mediana");