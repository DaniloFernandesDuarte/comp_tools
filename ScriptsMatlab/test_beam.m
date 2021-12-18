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

% laminados(1).force_in(Forcas)
% laminados
%% Definindo coordenadas dos pontos iniciais e finais das placas 
pontos = [
    1	0	0	;
    2	30.091	40.55	;
    3	80.655	68.293	;
    4	155.198	93.117	;
    5	270	113.714	;
    6	370	119.724	; %
    7	470	116.254	;
    8	641.385	90.619	;
    9	721.466	71.17	;
    10	864.411	35.827	;
    11	1000	0	;
    12	864.411	5.248	;
    13	721.466	-13.344	;
    14	641.385	-28.958	;
    15	470	-58.689	;
    16	370	-64.007	; %
    17	270	-61.823	;
    18	155.198	-50.388	;
    19	80.655	-36.294	;
    20	30.091	-21.198	];

%% Definindo conexões entre pontos e materiais das placas, 
%   em referência à ordem da matriz Laminados
m1 = 1;
m2 = 2;
m3 = 3;
placas = [
    1, 2, m1;
    2, 3, m1;
    3, 4, m1;
    4, 5, m1;
    5, 6, m2;
    6, 7, m2;
    7, 8, m1;
    8, 9, m1;
    9, 10, m1;
    10, 11, m1;
    11, 12, m1;
    12, 13, m1;
    13, 14, m1;
    14, 15, m1;
    15, 16, m2;
    16, 17, m2;
    17, 18, m1;
    18, 19, m1;
    19, 20, m1;
    20, 1, m1;
    6, 16, m3];

%% Testando a classe da viga
asa = CompositeSection(pontos, placas,laminados)
asa.PlotProfile
