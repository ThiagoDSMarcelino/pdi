% Thiago dos Santos Marcelino

clear; clc; close all;

ref = imread('einstein.gif');

file_names = {'einstein.gif', 'meanshift.gif', 'contrast.gif', 'impulse.gif', 'blur.gif', 'jpg.gif'};

labels = {'Original (ref)', 'Mean shifted', 'Contrast stretched', 'Impulse noise', 'Blurred', 'JPEG compressed'};

fprintf('%-22s  %10s  %10s\n', 'Imagem', 'MSE', 'SSIM');
fprintf('%s\n', repmat('-', 1, 46));

figure('Name', 'Einstein SSIM Demonstration', 'NumberTitle', 'off');

for i = 1:length(file_names)
    img = imread(file_names{i});

    mse_val  = immse(img, ref);
    ssim_val = ssim(img, ref);

    fprintf('%-22s  %10.4f  %10.4f\n', labels{i}, mse_val, ssim_val);

    subplot(2, 3, i);
    imshow(img);
    title(sprintf('%s\nMSE=%.1f | SSIM=%.4f', labels{i}, mse_val, ssim_val), ...
        'FontSize', 7);
end

% Resultados
%
% Imagem                         MSE        SSIM
% ----------------------------------------------
% Original (ref)              0.0000      1.0000
% Mean shifted              143.9945      0.9873
% Contrast stretched        144.2188      0.9012
% Impulse noise             143.9390      0.8395
% Blurred                   143.9085      0.7022
% JPEG compressed           141.9529      0.6699
% 
% Resposta questão 1
% (c)
% 
% Resposta questão 2
% (b)