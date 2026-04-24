% Thiago dos Santos Marcelino

clear; clc; close all;

%% Carrega imagem
img = imread('cameraman.tif');
 
% -------------------------------------------------------------------
% O detector Canny usa dois limiares (histerese):
%   Thigh: pixels com gradiente > Thigh são definitivamente borda
%   Tlow:  pixels com gradiente entre Tlow e Thigh são borda apenas
%          se conectados a um pixel de borda forte
% Sintaxe: edge(I, 'canny', [Tlow Thigh], sigma)
% -------------------------------------------------------------------
 
%% Combinação 1: limiares baixos -> mais bordas, mais ruído
Tlow1  = 0.04;
Thigh1 = 0.10;
borda1 = edge(img, 'canny', [Tlow1 Thigh1]);
 
%% Combinação 2: limiares altos -> menos bordas, mais seletivo
Tlow2  = 0.15;
Thigh2 = 0.40;
borda2 = edge(img, 'canny', [Tlow2 Thigh2]);
 
%% Exibição
figure('Name', 'Atividade 6.2 - Canny com diferentes limiares', ...
       'NumberTitle', 'off');
 
subplot(1, 3, 1);
imshow(img);
title('Imagem Original');
 
subplot(1, 3, 2);
imshow(borda1);
title({sprintf('Canny: Tlow=%.2f, Thigh=%.2f', Tlow1, Thigh1), ...
       'Limiares baixos (mais sensível)'});
 
subplot(1, 3, 3);
imshow(borda2);
title({sprintf('Canny: Tlow=%.2f, Thigh=%.2f', Tlow2, Thigh2), ...
       'Limiares altos (mais seletivo)'});
 
%% Informações
fprintf('=== Informações das detecções ===\n');
fprintf('Comb. 1 [Tlow=%.2f, Thigh=%.2f]: %d pixels de borda detectados\n', ...
    Tlow1, Thigh1, sum(borda1(:)));
fprintf('Comb. 2 [Tlow=%.2f, Thigh=%.2f]: %d pixels de borda detectados\n', ...
    Tlow2, Thigh2, sum(borda2(:)));