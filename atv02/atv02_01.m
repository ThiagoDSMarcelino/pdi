% Thiago dos Santos Marcelino

close all; clear all; clc;

G = imread('cameraman.tif');

nr = size(G,1);
nc = size(G,2);
[X,Y] = meshgrid(1:nr,1:nc);

N = nr*nc;
I = [X(:)';
     Y(:)';
     ones(1,N)];

ang = 30*pi/180; % 30°
T = [ cos(ang) sin(ang) 0;
     -sin(ang) cos(ang) 0;
       0        0       1];

K = T*I;

temp1 = min(K, [], 2);
m = repmat(temp1, 1, N);
temp2 = K - m;
Kadj = 1 + floor(temp2);

nrOut = max(Kadj(1,:));
ncOut = max(Kadj(2,:));
Gout = uint8(zeros(nrOut, ncOut));

for k = 1:length(Kadj)
    Gout(Kadj(1,k), Kadj(2,k)) = G(I(1,k), I(2,k));
end

imshow(Gout);

% Porque aparecem pixels pretos ("buracos") na imagem rotacionada?

% O programa tem como objetivo rotacionar a imagem em 30°
% Para fazer isso, ele cria uma matriz de rotação chamada T
% E uma matriz I que tem as coordenadas de todos os píxeis da imagem nas
% duas primeiras linhas e na terceira tem o valor 1, isso para ser
% possível multiplicar T * I

% Após fazer essas multiplicações, geramos uma matriz com valores
% quebrados e logicamente não podem ser usados como índices em uma matriz.
% Por isso usamos o floor no Kadj e o mais 1 é por conta do MATLAB os
% índices começam em 1

% Essa transformação pode acarretar alguns erros, como dois píxeis serem
% mapeados para o mesmo local, e outros locais não terem nenhum píxel sendo
% mapeado para ele

% Assim, na hora em que passamos a conversão de índices para a matriz Gout 
% temos alguns espaços que não são preenchidos, e por que originalmente 
% essa matriz é totalmente zerada, temos a cor preta nesses locais