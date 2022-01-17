% Ferramenta para o design e análise de um tubo laminado
% Written by: Danilo F. Duarte
% Started: 28/10/20 - Started code
% Updated: 29/10/20 - implementando funções
% Updated: 19/01/21 - reviewed
%                   - Atualizando COMPOSIT_LIST para COMPOSIT_LIST_V02
%                   - Unidades métricas!
%                   
% PURPOSE
% - Use the plate stifness matrix to compute safty factors of a laminate
%   tube
%
% TO DO
%
clc;
clear;
close all;

%% Defininindo a configuração do laminado
% L=[material,ângulo [dg],espessura [mm]]
% Material is defined as given by the function COMPOSITE_LIST(material):

tk1 = 0.42 * (10^(-3));    % [m]
dg = 15;
L = [
    27,    dg    , tk1
    27,    -dg   , tk1
    27,    -dg   , tk1
    27,    dg    , tk1
    ];

%% Definindo dimensões do tubo
comprimento = 2.26;          % [m]
posicao_cg  = 0.5350;        % [m]
diametro    = 0.141;         % [m]
raio        = diametro/2;    % [m]
espessura = sum(L,1);        % [m]
espessura = espessura(1,3);  % [m]
peso = 250;                  % [N]
empuxo = 2500;               % [N]
momento_de_inercia = (diametro^4-(diametro-espessura)^4)*pi/4;   % [m^4]
area = pi*(diametro^2-(diametro-espessura)^2)/4;                 % [m^2]

%% Definindo os carregamentos
% % Calculando tensões normais
% % Considerando o foguete como uma viga simplesmente apoiada
% % Calculando tensões de cisalhamento
% % Shear = shear_flow * thickness (q=tau*t). Megson Pg. 538

% Calculando tensões normais em N/m
M_X = (peso*posicao_cg*(comprimento-posicao_cg))/comprimento; % [Nm]
sigma_z_max = (M_X/(pi * (raio^3) * espessura))*raio;         % [Pa]
q_z_max = sigma_z_max * espessura;                            % [N/m]
q_z_max = q_z_max + (empuxo/(2*pi*raio))                      % [N/m]

% Calculando o fluxo de cisalhamento N/m 
% (lembrar de adicionar os efeitos da torção)
S_Y = peso*(comprimento-posicao_cg)/comprimento
qs_max = S_Y/(pi * raio)

%% Definindo as matrizes de carregamento
Nx  = q_z_max;                    % [N/m]
Ny  = 0;                          % [N/m]   
Nxy = 0; %-q * (10^3)            % [N/m]

% Nx= (empuxo*(2*pi*raio));     % [N/m]
% Ny= 0;                        % [N/m]   
% Nxy= qs_max; %-q * (10^3)     % [N/m]

%% Definindo as matrizes de carregamento 
% F_in  = [Nx; Ny; Nxy; Mx; My; Mxy] for inplane loads in N/m and Nm/m for
% the forces and moments respectively
% F_out = [Vy, Vx] for out of plane loads
F_in = [Nx; Ny; Nxy; 0; 0; 0];
F_out =[0; 0];
% F_in = [-1; 0; 0; 0; 0; 0]*10e8; % [[N/m],[N/m],[N/m],[Nm/m],[Nm/m],[Nm/m]] 
% F_out =[0; 0];

%% Computando cargas sobre o laminado
[L,Q,ABD,H] = COMPUTE_ABD(L);
[S_laminate] = LAMINATE_MODULI(ABD,H,espessura)
Ex = 1/S_laminate(1,1);

%% Definindo a carga crítica de flambagem (eq 10.15)
%                 Le = k l
% End-restrain      |     K    | K steel | K wood 
% ------------------------------------------------
% Pinned-Pinned     |     1    |  1.0    | 1.0
% Clamped-clamped   |     0.5  |  0.65   | 0.65
% Pinned-clamped    |     0.7  |  0.8    | 0.8
% Clamped-free      |     2.0  |  2.1    | 2.4
% Le = k * l -------------------------------------
k      = 2.4;          % Pinned-Pinned
l_comp = 2;
l_eq   = l_comp * k;
%Ex     = 45e9;         % corrigir essa linha para usar a tensão equivalente
P_cr   = (Ex * momento_de_inercia * pi^2)/(l_eq)
Sf_euler = P_cr/empuxo;

%% Computando propriedades do tubo
[custo,peso,sf] = ROCKET_TUBE(L,F_in,F_out,diametro,comprimento);
Sf_euler



