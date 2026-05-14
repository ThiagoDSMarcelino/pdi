% Thiago dos Santos Marcelino
clear; clc; close all;

mugsDir = dir('mugs');
samplesFolders = mugsDir([mugsDir.isdir]);
samplesFolders = samplesFolders(~ismember({samplesFolders.name},{'.','..'}));
samplesCount = length(samplesFolders);

for i = 1:samplesCount
    path   = fullfile('mugs', samplesFolders(i).name);
    images = dir(fullfile(path, '*.png'));
    imagesCount = length(images);

    figure('Name', samplesFolders(i).name, 'NumberTitle', 'off', ...
           'Units', 'normalized', 'Position', [0 0 1 0.6])

    for j = 1:imagesCount

        img = imread(fullfile(path, images(j).name));

        % Segmentação
        th = graythresh(img);
        bw = imbinarize(img, th);
        if sum(bw(:)) > numel(bw)/2
            bw = ~bw;
        end

        % Morfologia
        se = strel('disk', 3);
        bw = imopen(bw, se);
        bw = imclose(bw, se);
        bw = imfill(bw, 'holes');

        % Maior componente
        [rv, ~] = bwlabel(bw, 8);
        props   = regionprops(rv, 'Area', 'PixelIdxList', 'BoundingBox');
        [~, maior] = max([props.Area]);

        bw_caneca = false(size(bw));
        bw_caneca(props(maior).PixelIdxList) = true;

        % --- Linha 1: original ---
        subplot(3, imagesCount, j)
        imshow(img)
        title(num2str(j), 'FontSize', 7)

        % --- Linha 2: bw após morfologia (todos os objetos) ---
        subplot(3, imagesCount, imagesCount + j)
        imshow(bw)
        title('morph', 'FontSize', 7)

        % --- Linha 3: só a caneca (maior componente) ---
        subplot(3, imagesCount, 2*imagesCount + j)
        imshow(bw_caneca)
        title('caneca', 'FontSize', 7)

    end

    sgtitle(samplesFolders(i).name, 'FontSize', 12)
end