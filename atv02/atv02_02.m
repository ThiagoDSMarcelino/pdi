% Thiago dos Santos Marcelino

% Fecha todas as janelas abertas, limpa variáveis da memória e limpa o console
close all; clear all; clc;

% Lê a imagem e armazena na matriz.
G = imread('cameraman.tif');

% Obtém as dimensões da imagem
nr = size(G,1);
nc = size(G,2);

% Cria duas matrizes de coordenadas de todos os pixels
[X,Y] = meshgrid(1:nr,1:nc);

% Monta matriz homogênea
N = nr*nc;
I = [X(:)';
     Y(:)';
     ones(1,N)];

ang = 30*pi/180; % 30°

% Matriz de rotação
T = [ cos(ang) sin(ang) 0;
     -sin(ang) cos(ang) 0;
       0        0       1];

% Aplica matriz de rotação
K = T*I;

% Encontra o valor mínimo de cada linha
temp1 = min(K, [], 2);

% Replica esse vetor mínimo N vezes
m = repmat(temp1, 1, N);

% Translada todos os pontos para que o menor valor seja 0 
temp2 = K - m;

% Arredonda para baixo e soma 1 para que os índices comecem em 1
Kadj = 1 + floor(temp2);

% Cria imagem de saída
nrOut = max(Kadj(1,:));
ncOut = max(Kadj(2,:));
Gout = uint8(zeros(nrOut, ncOut));

% Para cada pixel k: pega o valor do pixel na imagem original G 
% na posição (I(1,k), I(2,k)) 
% e coloca na posição rotacionada (Kadj(1,k), Kadj(2,k)) em Gout.
for k = 1:length(Kadj)
    Gout(Kadj(1,k), Kadj(2,k)) = G(I(1,k), I(2,k));
end

% Exibe a imagem
imshow(Gout);
