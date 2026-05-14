% Thiago dos Santos Marcelino

clear; clc; close all;

mugsDir = dir('mugs');
samplesFolders = mugsDir([mugsDir.isdir]);
samplesFolders = samplesFolders(~ismember({samplesFolders.name},{'.','..'}));
samplesCount   = length(samplesFolders);

figure('Name','Resultado','NumberTitle','off',...
       'Units','normalized','Position',[0 0 1 1])

for i = 1:samplesCount

    path    = fullfile('mugs', samplesFolders(i).name);
    images  = dir(fullfile(path, '*.png'));
    imagesCount = length(images);
    scores  = zeros(1, imagesCount);

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
        props   = regionprops(rv, 'Area', 'PixelIdxList', 'BoundingBox', 'Centroid');
        [~, maxIndex] = max([props.Area]);

        bw_mug = false(size(bw));
        bw_mug(props(maxIndex).PixelIdxList) = true;
        mug_cx = props(maxIndex).Centroid(1);
        bb     = props(maxIndex).BoundingBox;
        mid_x = bb(1) + bb(3)/2;

        left_pixels  = sum(sum(bw_mug(:, 1:round(mid_x))));
        right_pixels = sum(sum(bw_mug(:, round(mid_x)+1:end)));

        scores(j) = right_pixels - left_pixels;

    end

    % Terminal
    fprintf('Scores [%s]: ', samplesFolders(i).name);
    fprintf('%6.1f  ', scores); fprintf('\n');
    
    [~, bestIdx] = max(scores);
    fprintf('[%s] → %s\n\n', samplesFolders(i).name, images(bestIdx).name);

    % Display: imagens da categoria + coluna extra com a escolhida
    for k = 1:imagesCount
        subplot(samplesCount, imagesCount+1, (i-1)*(imagesCount+1) + k)
        imshow(imread(fullfile(path, images(k).name)))

        if k == bestIdx
            title('✓','Color',[0 0.7 0],'FontSize',14,'FontWeight','bold')
        else
            title(num2str(k),'FontSize',7)
        end
    end

    % Coluna extra: imagem escolhida destacada
    subplot(samplesCount, imagesCount+1, (i-1)*(imagesCount+1) + imagesCount+1)
    imshow(imread(fullfile(path, images(bestIdx).name)))
    title({samplesFolders(i).name; ['→ img ' num2str(bestIdx)]},...
        'Color',[0 0.5 0],'FontSize',8,'FontWeight','bold')
end
