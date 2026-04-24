% Thiago dos Santos Marcelino

clear; clc; close all;

%% Carrega imagem
img = imread('sticknote_gray_01.png');
 
% Converte para escala de cinza se necessário
if size(img, 3) == 3
    img = rgb2gray(img);
end
 
%% ---- Parâmetro 1: Detecção de bordas com Canny ----
% O threshold do Canny controla quais bordas entram no acumulador da HT.
% Um valor mais alto filtra ruído e estruturas internas, mantendo apenas
% as bordas fortes (bordas do retângulo do sticky note).
% Ajuste este valor se a detecção não encontrar as 4 retas corretamente.
canny_threshold = [0.05, 0.15];  % [Tlow, Thigh]
 
BW = edge(img, 'canny', canny_threshold);
 
%% ---- Transformada de Hough ----
[H, theta, rho] = hough(BW);
 
%% ---- Parâmetro 2: Seleção de picos no acumulador ----
% NumPeaks: quantos picos (linhas candidatas) selecionar no acumulador.
% Usamos 4 porque o sticky note tem exatamente 4 bordas.
% Threshold: fração do pico máximo para ser considerado pico.
%   Aumentar o threshold torna a seleção mais restritiva.
num_peaks = 4;
peak_threshold = 0.3;  % 30% do valor máximo do acumulador
 
P = houghpeaks(H, num_peaks, 'Threshold', ceil(peak_threshold * max(H(:))));
 
%% ---- Extração dos segmentos de reta ----
% FillGap: une segmentos colineares separados por até N pixels
% MinLength: descarta segmentos menores que N pixels
lines = houghlines(BW, theta, rho, P, ...
    'FillGap', 50, ...
    'MinLength', 30);
 
%% ---- Exibição dos resultados ----
figure('Name', 'Atividade 6.3 - Transformada de Hough', 'NumberTitle', 'off');
 
subplot(2, 2, 1);
imshow(img);
title('Imagem Original');
 
subplot(2, 2, 2);
imshow(BW);
title({'Bordas (Canny)', sprintf('threshold=[%.2f, %.2f]', ...
    canny_threshold(1), canny_threshold(2))});
 
subplot(2, 2, 3);
imshow(imadjust(rescale(H)));
hold on;
plot(theta(P(:,2)), rho(P(:,1)), 's', ...
    'color', 'white', 'LineWidth', 2, 'MarkerSize', 10);
hold off;
title({'Acumulador da HT', sprintf('%d picos selecionados', num_peaks)});
xlabel('\theta (graus)'); ylabel('\rho (pixels)');
 
subplot(2, 2, 4);
imshow(img); hold on;
title(sprintf('Retas detectadas: %d', length(lines)));
 
% Paleta de cores para as 4 retas
cores = {'red', 'green', 'blue', 'yellow'};
 
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    cor = cores{mod(k-1, length(cores)) + 1};
    
    % Desenha a reta
    plot(xy(:,1), xy(:,2), 'LineWidth', 2, 'Color', cor);
    
    % Marca os extremos
    plot(xy(1,1), xy(1,2), 'x', 'LineWidth', 2, ...
        'MarkerSize', 10, 'Color', cor);
    plot(xy(2,1), xy(2,2), 'x', 'LineWidth', 2, ...
        'MarkerSize', 10, 'Color', cor);
    
    % Comprimento do segmento
    comprimento = norm(lines(k).point1 - lines(k).point2);
    fprintf('Reta %d: theta=%.1f°, rho=%.1f px, comprimento=%.1f px\n', ...
        k, lines(k).theta, lines(k).rho, comprimento);
end
hold off;
 
fprintf('\nTotal de retas detectadas: %d\n', length(lines));