clear;
close all;
clc;

%% Defininindo a configuração do laminado
% L=[material,ângulo [dg],espessura [mm]]
% Material is defined as given by the function COMPOSITE_LIST_V02(material):

h = 25; % mm
t = h/16;
b = h/2;
tk=t/6; % [mm]
mt=25; % Kevlar Epoxy

L1 = [
    mt,  +30  , tk
    mt,  -30  , tk
    mt,  0  , tk
    mt,  0  , tk
    mt,  -30  , tk
    mt,  +30  , tk
    ];

laminados(1) = Laminado(L1);

% laminados
%% Definindo coordenadas dos pontos iniciais e finais das placas 
pontos = [
    20, 0;
    0, 0;
    0, 20;];

%% Definindo conexões entre pontos e materiais das placas, 
%   em referência à ordem da matriz Laminados
m1 = 1;
m2 = 2;
m3 = 3;
placas = [
    1, 2, 1; 
    2, 3, 1];

%% Testando a classe da viga
viga = CompositeSection(pontos, placas,laminados);
viga.PlotProfile;

% %%
% Mx = 10;
% My = 0;
% viga = viga.BendingTension(Mx,My);
% sigma = viga.sigma_z_Bending

 
 