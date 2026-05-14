% Thiago dos Santos Marcelino

clear; clc; close all;

mugsDir = dir('mugs');
samplesFolders = mugsDir([mugsDir.isdir]);
samplesFolders = samplesFolders(~ismember({samplesFolders.name},{'.','..'}));
samplesCount = length(samplesFolders);

for i = 1:samplesCount

    path = fullfile('mugs', samplesFolders(i).name);
    images = dir(fullfile(path, '*.png'));
    imagesCount = length(images);
    scores = zeros(1, imagesCount);

    figure('Name', samplesFolders(i).name, 'NumberTitle', 'off', ...
           'Units', 'normalized', 'Position', [0 0 1 0.4])

    for j = 1:imagesCount

        img = imread(fullfile(path, images(j).name));

        % --- Segmentação Otsu ---
        th = graythresh(img);
        bw = imbinarize(img, th);

        if sum(bw(:)) > numel(bw)/2
            bw = ~bw;
        end

        subplot(2, imagesCount, j)
        imshow(img)
        title(images(j).name, 'FontSize', 7, 'Interpreter', 'none')

        subplot(2, imagesCount, imagesCount + j)
        imshow(bw)
        title('bw', 'FontSize', 7)

    end

    sgtitle(samplesFolders(i).name, 'FontSize', 12)
end