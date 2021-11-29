%% FUNCTION: Material List
% Written by: Danilo F. Duarte
% Started: 18/01/21 - Started code
% Updated: 19/01/21 - Implementado extração de variáveis
% Updated: 27/02/21 - ussando mm e MPa nessa versão :/
%
%
% TO DO: - [x] Padronizar unidades das variáveis (metric)
%
% PURPOSE
% - Listar propriedades de compositos para facilitar a implementação de
%   funções que utilizam esses valores
% 
% INPUTS
%
% OUTPUTS:
% MECHANICAL=[E1,E2,v12,v21,v23,G12,G13,G23]
% STRENGH=[F1t,F1c,F2t,F2c,F6];
% PHYSICAL=[density_area,cost_area];


function[PHYSICAL, MECHANICAL, STRENGH] = COMPOSITE_LIST_V02(ITEM)
    %% Abrindo tabelas para extrair dados
    CompositeTable = readtable("tabela_barbeiro_v03.csv");
    CompositeTable.MaterialType = categorical(CompositeTable.MaterialType);
    
    %% Declarando propriedades dos materiais usando COMPOSITE_LIST
    % PHYSICAL
    fiber_volume =  CompositeTable.Vf(ITEM,1);          % [Adimensional]
    cost_area    =  CompositeTable.cost(ITEM,1);        % [Reais/m^2]
    PlyThickness =  CompositeTable.tk_mm(ITEM,1);       % [mm]
    density      =  CompositeTable.density_gcc(ITEM,1); % [g/cm^3]
    density_area =  (PlyThickness/10)*(10^4)*density;   % [g/m^2]
    
    % MECHANICAL
    E1  = CompositeTable.E1_GPa(ITEM,1)*(10^3);  % [MPa]
    E2  = CompositeTable.E2_GPa(ITEM,1)*(10^3);  % [MPa]
    v12 = CompositeTable.V12(ITEM,1);            % [Adimensional]
    v21 = CompositeTable.V23(ITEM,1);            % [Adimensional]
    v23 = v12;                                   % [Adimensional]
    G12 = CompositeTable.G12_GPa(ITEM,1)*(10^3); % [MPa]
    G13 = G12 ;                                  % [MPa]
    G23 = E2 / (2*(1+v23));                      % [MPa] 
    
    % STRENGH
    F1t = CompositeTable.F1t_MPa(ITEM,1); % [MPa]
    F1c = CompositeTable.F1c_MPa(ITEM,1); % [MPa]
    F2t = CompositeTable.F2t_MPa(ITEM,1); % [MPa]
    F2c = CompositeTable.F2c_MPa(ITEM,1); % [MPa]
    F6  = CompositeTable.F6_MPa(ITEM,1) ; % [MPa]
    
    %% Definindo Outputs
    MECHANICAL = [E1,E2,v12,v21,v23,G12,G13,G23];
    STRENGH    = [F1t,F1c,F2t,F2c,F6]';
    PHYSICAL   = [density_area,cost_area];
end
