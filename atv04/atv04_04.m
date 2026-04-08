% Thiago dos Santos Marcelino

clear; clc; close all;

img = imread("flowervaseg.png");

sz = size(img);

%% Composite Laplacian

mascCL = [
    0 -1  0;
    -1  5 -1;
    0 -1  0;
    ];

%% Composite Laplacian Variante

mascCLV = [
    -1 -1 -1;
    -1  9 -1;
    -1 -1 -1;
    ];


%% Outputs
outputCL    = zeros(sz, 'double');
outputCLV   = zeros(sz, 'double');

for i = 2:(sz(1) - 1)
    for j = 2:(sz(2) - 1)
        region = double(img(i-1:i+1, j-1:j+1));

        resCL = region .* mascCL;
        outputCL(i, j) = sum(resCL(:));

        resCLV = region .* mascCLV;
        outputCLV(i, j) = sum(resCLV(:));
    end
end

outputCL = uint8(max(0, min(255, outputCL)));
outputCLV = uint8(max(0, min(255, outputCLV)));

%% Plot

figure;

subplot(1, 3, 1); imshow(img);          title("Originial");
subplot(1, 3, 2); imshow(outputCL);     title("Composite Laplacian");
subplot(1, 3, 3); imshow(outputCLV);    title("Composite Laplacian Variante");