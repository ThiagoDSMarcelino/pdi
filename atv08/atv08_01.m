% Thiago dos Santos Marcelino

clear; clc; close all;

%% 1. Carregando arquivos

folder = 'L';
files = dir(fullfile(folder, '*.png'));

n = length(files);
classifications = cell(1, n);
images = cell(1, n);

%% 2. Processamento
for i = 1:n
    path = fullfile(folder, files(i).name);
    img = imread(path);
    images{i} = img;

    th = graythresh(img);
    bw = imbinarize(img, th);

    if sum(bw(:)) > numel(bw)/2
        bw = ~bw;
    end

    se = strel('disk', 3);
    bw = imopen(bw, se);
    bw = imclose(bw, se);
    bw = imfill(bw, 'holes');
    
    [rv, nobj] = bwlabel(bw, 8);

    if nobj == 0
        classifications{i} = 'Indefinido';
        continue;
    end

    props = regionprops(rv, ...
        'Area', 'BoundingBox', 'Perimeter', ...
        'Eccentricity', 'Solidity', 'Extent');

    areas = [props.Area];
    [~, idx] = max(areas);
    p = props(idx);

    solidity = p.Solidity;

    ecc = p.Eccentricity;

    bb       = p.BoundingBox;
    aspRatio = bb(3) / bb(4);

    circ = (4 * pi * p.Area) / (p.Perimeter ^ 2);

    if solidity < 0.80
        rotulo = 'Estrela';

    elseif ecc > 0.75 && circ < 0.65 && solidity < 0.9
        rotulo = 'Bispo';

    elseif aspRatio >= 0.85 && aspRatio <= 1.15
        rotulo = 'Quadrado';

    else
        rotulo = 'Retangulo';
    end

    classifications{i} = rotulo;

    if strcmp(rotulo, 'Bispo')
        fprintf('[%d] %-20s | Sol=%.2f | Ecc=%.2f | AR=%.2f | Circ=%.2f → %s\n', ...
            i, files(i).name, solidity, ecc, aspRatio, circ, rotulo);
    end
end

%% 3. Plotar imagens com suas classificações
figure('Name', 'Classificação - Aula 08', 'NumberTitle', 'off')

for i = 1:n
    subplot(2, 4, i)
    imshow(images{i})
    title(classifications{i}, 'FontSize', 12, 'FontWeight', 'bold')
end

sgtitle('Classificação das imagens', 'FontSize', 14)