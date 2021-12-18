% Calculando a riginez "equivalente" de um laminado
% Written by: Danilo F. Duarte
% Started: 08/11/20 - Started code
% Updated: 19/01/21 - reviewed
%                   - Atualizando COMPOSIT_LIST para COMPOSIT_LIST_V02
%                   - Unidades métricas!
%
% PURPOSE
% - Compute the laminate moduli matrix
% 
% INPUTS
% - ABD = ABD Matrix
% - H   = Transverseshear stiffness
%
% OUTPUTS
% - Laminate S matrix (from the compliance equation)
% - Laminate S* matrix ()
%
% TO DO
%
function[Ex,Ey,vxy,Gxy,Gyz,Gxz] = LAMINATE_MODULI_BULK(ABD,H,thickness)

% Conferindo se o laminado possui uma sequencia simétrica (D=0)
% check_symetry= ABD(4:end,4:end)
% if check_symetry ~= 0
%     disp("A matriz ABD não é de um laminado simétrico")
% end

A=ABD(1:3,1:3);
H=H; 
t=thickness;  % [m]
Ex=(A(1,1)*A(2,2)-(A(1,2)^2))/(t*A(2,2));         % [Pa]
Ey=(A(1,1)*A(2,2)-(A(1,2)^2))/(t*A(1,1));         % [Pa]
vxy= A(1,2)/A(2,2);                               % [Adimensional]
Gxy= A(3,3)/t;                                    % [Pa]
Gyz= H(1,1)/t;                                    % [Pa]
Gxz= H(2,2)/t;                                    % [Pa]

% S=[
%     1/Ex      , -vxy/Ex  ,  0
%     -vxy/Ex   , 1/Ey     ,  0
%     0         , 0        ,  1/Gxy
% ];

end


