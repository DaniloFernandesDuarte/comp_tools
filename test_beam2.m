clear;
close all;
clc;

%% Defininindo a configuração do laminado
% L=[material,ângulo [dg],espessura [mm]]
% Material is defined as given by the function COMPOSITE_LIST_V02(material):

tk=3; % [mm]
mt=1; % E-glass Epoxy

L1 = [
    mt,  30  , tk
    mt,  0  , tk
    mt,  30  , tk
    ];
tk=tk*2;
L2 = [
    mt,  30 , tk
    mt,  0  , tk
    mt,  30 , tk
    ];
tk=tk*(3/2);
L3 = [
    mt,  30 , tk
    mt,  0  , tk
    mt,  30 , tk
    ]; 

laminados(1) = Laminado(L1);
laminados(2) = Laminado(L2);
laminados(3) = Laminado(L3);
% laminados
%% Definindo coordenadas dos pontos iniciais e finais das placas 
pontos = [
    20, 0;
    0, 0;
    0, 20];

%% Definindo conexões entre pontos e materiais das placas, 
%   em referência à ordem da matriz Laminados
m1 = 1;
m2 = 2;
m3 = 3;
placas = [
    1, 2, 1; 
    2, 3, 1;];

%% Testando a classe da viga
asa = CompositeSection(pontos, placas,laminados)
asa.PlotProfile
