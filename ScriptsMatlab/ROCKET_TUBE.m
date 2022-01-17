% Calculando a riginez de uma placa de material compósito de n lâminas
% Written by: Danilo F. Duarte
% Started: 13/08/20 - Started code
% Updated: 14/08/20 - Calculândo A,B e D corretamente
% Updated: 28/10/20 - Transformar em uma função de imput L 
%                   - Implementado o uso da COMPOSIT_LIST
%                   - Reuter matrix implemented
% Updated: 19/01/21 - reviewed
%                   - Atualizando COMPOSIT_LIST para COMPOSIT_LIST_V02
%                   - Unidades métricas!
%
% PURPOSE
% - Compute the plate stiffness equations
% - Based on eq.6.19 on the Barbero's book
% 
% INPUTS
% - LAMINADO=[material,ply angle [dg],thickness]'      Laminate definition
% - LAMINADO = [
%         1,  00, tk
%         1,  90, tk
%         1,  00, tk
%         ]; % Example of LAMINADO matrix (tk in [mm] )
% OUTPUTS
% - ABD = ABD Matrix
% - H   = Transverseshear stiffness
%
% TO DO
%
function[custo,peso,sf] = ROCKET_TUBE(LAMINADO,F_in,F_out,diametro,comprimento)
%% Defininindo a configuração do laminado
% L=[material,ângulo [dg],espessura [mm]]
% Material is defined as given by the function COMPOSITE_LIST(material)
L = LAMINADO;
n = size(L,1);
% Definindo a resistência das lâminas
i=1;
while i<=n
    [PHYSICAL(:,:,i), ~, STRENGHT(:,:,i)] = COMPOSITE_LIST_V02(L(i,1)); 
    i=i+1;
end
% clear MECHANICAL 
PHYSICAL = sum(PHYSICAL,3);
%% Determinando a matriz ABD do laminado (plate stifness)
[L,Q,ABD,H]=COMPUTE_ABD(L);

%% Definindo as matrizes de carregamento 
% F_in  = [Nx; Ny; Nxy; Mx; My; Mxy] for inplane loads in N/m or Nm/m
% F_out = [Vy, Vx] for out of plane loads
%F_in = [1; 0; 0; 0; 0; 0]*9*10^8;
%F_out =[0; 0;];

%% Computando deformações
% Deformacao_in = [ex0; ey0; gamaxy0; kx; ky; kxy]
deformacao_in = inv(ABD) * F_in ;
% Deformacao_out = [ex0; ey0; gamaxy0; kx; ky; kxy]
deformacao_out = inv(H) * F_out ; 

%% Computando as deformações e tensões das lâminas individuais 
% The reuter matrix is used to transform the dformations as given by
% eq.5.42: {exy}=[R][T]inv[R]{e12}
reuter = [ 1 , 0 , 0  ;
           0 , 1 , 0  ;
           0 , 0 , 2 ];
% From Barbeiro's equation 6.7
i=1;
while i<=n
    % Deformação na direção do laminado [Adimensional]
    deff_xy(:,:,i) = deformacao_in(1:3,1) - L(i,4)*deformacao_in(4:end,1);
    % Deformação na direção das lâminas, eq.5.42 [Adimensional]
    deff_12(:,:,i) = reuter * COMPUTE_T(L(i,2)) * inv(reuter) * deff_xy(:,:,i);
    % Stresses nas direções das lâminas [Pa]
    stress_12(:,:,i) = Q(:,:,i) * deff_12(:,:,i); 
    stress(:,i)=stress_12(:,:,i);
    i=i+1;
end

%% Calculando os fatores de segurança das lâminas 
%  STRENGH=[F1t,F1c,F2t,F2c,F6]';
i=1;
while i<=n
    % Max stress method
    % - R = [R1,R2,R6]      Strengh ratio in the directions 1, 2, 6
    [R] = SF_MAX_STRESS(STRENGHT(:,:,i),stress_12(:,:,i)); 
    max_stress_sf(:,i) = [R];
    % Tsai-Wu method
    % - Sfa = Actual state of stress
    % - Sfr = Reversed in sign state of stress
    [Sfa, Sfr] = SF_TSAI_WU(STRENGHT(:,:,i),stress_12(:,:,i)); 
    tsai_wu_sf(:,i) = [Sfa, Sfr]';
    % Hashin Rotem method
    % - fiber_fail  = Fiber safety factor
    % - matrix_fail = Matrix safety factor
    [fiber_fail, matrix_fail] = SF_HASHIN_ROTEM(STRENGHT(:,:,i),...
                                stress_12(:,:,i)); 
    hashin_rotem_sf(:,i)=[1./fiber_fail, 1./matrix_fail]';  
    i=i+1;    
end

%% Printing relevant data
L 
stress 
max_stress_sf 
tsai_wu_sf=tsai_wu_sf(1,:) 
hashin_rotem_sf 


%% Dados do  tubo do foguete
% PHYSICAL=[density_area,cost_area];
area_tubo = (diametro*pi) * comprimento;
PHYSICAL
peso  = area_tubo * PHYSICAL(1,1)
custo = area_tubo * PHYSICAL(1,2)  
sf    = min(tsai_wu_sf)

% densidade_area  % Com resina
% custo_area      % Sem resina
% peso_total      % Com resina
% custo_total     % Sem resina

end









