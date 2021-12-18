% FUNCTION: COMPUTE QI
% Written by: Danilo F. Duarte
% Started: 08/08/20
% Updated: 08/08/20 - Started code
%                   - Works as expected
% Updated: 19/01/21 - reviewed
%
% PURPOSE
% - Compute the matrix QI whitch is the inverse of the inatralaminar
%   compliance matrix
% - It is eq.5.22 on the Barbero book
% - The matrix SI is QI^-1
% - Sigma 4 e 5 = QI * gama 4 e 5

% 
% INPUTS
% - G13        : Intralaminar shear modulus on 13 plane
% - E2         : Youngs modulus on 2 direction
% - poison23   : Poison Ration on the 12 direction
%
% OUTPUTS
% - Q* : Matrix Q* (eq.5.21)


function[QI] = COMPUTE_QI(G13,E2,poison23)
   
    G23 = E2 / (2*(1+poison23));
    QI(1,1) = G23 ;
    QI(2,2) = G13 ;
  
    Q(1,2) = 0;
    Q(2,1) = 0;
        
end