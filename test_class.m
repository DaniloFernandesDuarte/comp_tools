clear;
close all;
clc;
%% Defininindo a configuração do laminado
% L=[material,ângulo [dg],espessura [mm]]
% Material is defined as given by the function COMPOSITE_LIST_V02(material):

tk=3; % [mm]
mt=1; % E-glass Epoxy

L = [
    mt,  30  , tk
    mt,  0  , tk
    ];

F_in = [1; 0; 0; 0; 0; 0]*9*10^8;
F_out =[0; 0;];

laminado1 = Laminado(L)
laminado1 = laminado1.force_in(F_in)

%% 
laminado1 = Laminado(L);
laminado2 = Laminado(L);

laminados = [laminado1, laminado2]
%%
laminados(1).Exm