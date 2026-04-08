% Thiago dos Santos Marcelino

clear; clc; close all;

img = imread('gDSC04422m16.png');

[M, N] = size(img);

%% Histograma original
hist_orig = histcounts(img, 0:256);

%% Histograma normalizado
hist_norm = hist_orig / (M * N);

%% CDF
cdf = cumsum(hist_norm);

%% Níveis de cinza arredondados
lut = uint8(cdf .* 255);

%% Aplicar filtro
img_eq = intlut(img, lut);

%% Comparar imagens

figure;

subplot(2, 2, 1); imshow(img);      title('Original');
subplot(2, 2, 2); imshow(img_eq);   title('Equalizada');

subplot(2, 2, 3); histogram(img, 256);      title('Hist. Original');
subplot(2, 2, 4); histogram(img_eq, 256);   title('Hist. Equalizada');
