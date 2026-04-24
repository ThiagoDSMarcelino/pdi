% Thiago dos Santos Marcelino

clear; clc; close all;

%% Carrega imagem
img = imread('cameraman.tif');
img = double(img);
 
%% Máscaras Sobel
% Gradiente horizontal (Gh): detecta bordas verticais
Kh = [-1  0  1;
      -2  0  2;
      -1  0  1];
 
% Gradiente vertical (Gv): detecta bordas horizontais
Kv = [-1 -2 -1;
       0   0  0;
       1   2  1];
 
%% Convoluções
Gh = imfilter(img, Kh, 'replicate');
Gv = imfilter(img, Kv, 'replicate');
 
%% Método 1: Norma euclidiana  M = sqrt(Gh² + Gv²)
M_euclidiana = sqrt(Gh.^2 + Gv.^2);
 
%% Método 2: Soma dos valores absolutos  M = |Gh| + |Gv|
M_absoluta = abs(Gh) + abs(Gv);
 
%% Normalização para exibição [0, 255]
M_euclidiana_norm = M_euclidiana / max(M_euclidiana(:)) * 255;
M_absoluta_norm   = M_absoluta   / max(M_absoluta(:))   * 255;
 
%% Exibição
figure('Name', 'Atividade 6.1 - Comparação Sobel', 'NumberTitle', 'off');
 
subplot(1, 3, 1);
imshow(uint8(img));
title('Imagem Original');
 
subplot(1, 3, 2);
imshow(uint8(M_euclidiana_norm));
title({'Método 1: Norma Euclidiana', 'M = sqrt(Gh² + Gv²)'});
 
subplot(1, 3, 3);
imshow(uint8(M_absoluta_norm));
title({'Método 2: Soma dos Absolutos', 'M = |Gh| + |Gv|'});
 
%% Comparação numérica
disp('=== Comparação entre os métodos ===');
fprintf('Norma euclidiana  - Max: %.2f  |  Média: %.4f\n', ...
    max(M_euclidiana(:)), mean(M_euclidiana(:)));
fprintf('Soma dos absolutos - Max: %.2f  |  Média: %.4f\n', ...
    max(M_absoluta(:)), mean(M_absoluta(:)));
 
% Diferença relativa média entre os dois métodos
diff_relativa = abs(M_euclidiana - M_absoluta) ./ (M_euclidiana + eps);
fprintf('Diferença relativa média: %.4f%%\n', mean(diff_relativa(:)) * 100);
