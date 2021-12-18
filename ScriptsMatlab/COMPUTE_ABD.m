% Calculando a riginez de uma placa de material compósito de n lâminas
% Written by: Danilo F. Duarte
% Started: 13/08/20 - Started code
% Updated: 14/08/20 - Calculândo A,B e D corretamente
% Updated: 28/10/20 - Transformar em uma função de imput L 
%                   - Implementado o uso da COMPOSIT_LIST
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
%         ]; % Example of LAMINADO matrix
% OUTPUTS
% - ABD = ABD Matrix
% - H   = Transverseshear stiffness
%
% TO DO
%
function[L,Q,ABD,H,QT] = COMPUTE_ABD(LAMINADO)
%% Imputs
% Definindo a configuração dos laminados 
% [Material, Ângulo deg, tk [m]]
L=LAMINADO;
% Obtendo o número de lâminas
n=size(L,1);
% Espessura total:
tt=sum(L,1);  % [m]
tt=tt(1,3);   % [m]
% Adicionândo a posição das lâminas na matriz L
k=1;
while k<=n
    if k>1;
        L(k,4)= (L(k-1,4) + (L(k-1,3) + L(k,3))/2);
    else
        L(k,4)= -((tt/2) - L(1,3)/2);
    end
    k=k+1;
end
% Declarando propriedades dos materiais usando COMPOSITE_LIST
%  MECHANICAL=[E1,E2,v12,v21,v23,G12,G13,G23]
%  STRENGH=[F1t,F1c,F2t,Ftc,F6];
i=1;
while i<=n
    [PHYSICAL, MECHANICAL, STRENGH(i,:)] = COMPOSITE_LIST_V02(L(i,1));
    E1(1,i)       = MECHANICAL(1,1); % [Pa]
    E2(1,i)       = MECHANICAL(1,2); % [Pa]
    poison12(1,i) = MECHANICAL(1,3); % [Adimensional]
    poison23(1,i) = MECHANICAL(1,5); % [Adimensional]
    G12(1,i)      = MECHANICAL(1,6); % [Pa]
    G13(1,i)      = MECHANICAL(1,7); % [Pa]
    G23(1,i)      = MECHANICAL(1,8); % [Pa] 
    i=i+1;
end
clear MECHANICAL 
clear PHYSICAL 
% Não preciso dessa variável
% se eu for reescrever o código, usar para os cálculos das matrizes
%% Computando matrizes de propriedades das varias lâminas
i=1;
while i<=n
    % Stifness matrices
    Q(:,:,i)  = COMPUTE_Q(E1(1,i),E2(1,i),poison12(1,i),G12(1,i));
    QI(:,:,i) = COMPUTE_QI(G13(1,i),E2(1,i),poison23(1,i));
    % Transformation Matrices
    a(:,:,i)  = COMPUTE_A(L(i,2));
    T(:,:,i)  = COMPUTE_T(L(i,2));
    % Transformed reduced stifness (QT and QIT) (T^-1 * Q * T^-1transposta)
    QT(:,:,i)  = inv(T(:,:,i))*Q(:,:,i)*inv(T(:,:,i))';
    QIT(:,:,i) = a(:,:,i) * QI(:,:,i) * a(:,:,i)' ; 
    % Contador do loop while
    i=i+1;
end
%% Computando matrizes de propriedades do lâminado
% Criando matrizes temporárias contendo os elementos dos somatórios dos
% componenetes das matrizes de rigidez da placa
k=1;
while k<=n
   % Extensional stiffness matrix A:
   A0(:,:,k) = QT(:,:,k) * L(k,3);
   % Bending extension coupling stiffness matrix B:
   B0(:,:,k) = -1 * QT(:,:,k)* L(k,3) * L(k,4);
   % Bending stiffness matrix D:
   D0(:,:,k) = QT(:,:,k)* ( (L(k,3)*(L(k,4)^2))+((L(k,3)^3)/12));
   % Transverse shear stiffness:
   H0(:,:,k) = (-5/4) * QIT(:,:,k)*...
               (L(k,3)- (4/(tt^2))*((L(k,3)*(L(k,4)^2))+((L(k,3)^3)/12)));
   %contador
   k=k+1;
end
    
% S = sum(X,DIM) sums "X" along the dimension "DIM".
% Extensional stiffness matrix A
A = sum(A0,3);
% Bending extension coupling stiffness matrix B
B = sum(B0,3);
% Bending stiffness matrix D
D = sum(D0,3);
% Transverse shear stiffness
H= sum(H0,3);

% A riginez de uma placa de n lâminas é dada então por:
stiffness=[A,B;B,D];

%% Definindo Outputs
ABD=stiffness;

end





