% Thiago dos Santos Marcelino

clear; clc; close all;

%% Mascara 3X3
box = ones(3,3) / 9;

figure;
bar3(box);
title('Box Filter 3x3');
xlabel('Coluna');
ylabel('Linha');
zlabel('Valor');


%% Filtro Gaussiano 5x5 - sigma = 1
sigma = 1;
sz = 5;
half = floor(sz / 2);

gauss = zeros(sz, sz);

for i = 1:sz
    for j = 1:sz
        x = j - half - 1;
        y = i - half - 1;
        gauss(i, j) = (1 / (2 * pi * sigma^2)) * exp(-((x^2 + y^2) / (2 * sigma^2)));
    end
end

% Normalizar para a imagem não ficar nem mais clara e nem mais escura
gauss = gauss / sum(gauss(:));

figure;
bar3(gauss);
title('Filtro Gaussiano 5x5 (sigma=1)');
xlabel('Coluna');
ylabel('Linha');
zlabel('Valor');