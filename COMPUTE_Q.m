% FUNCTION: COMPUTE Q
% Written by: Danilo F. Duarte
% Started: 20/07/20
% Updated: 08/08/20 - Started code
%                   - Works as expected
% Updated: 19/01/21 - reviewed
%
% PURPOSE
% - Compute the matrix Q whitch is the inverse of the compliance matrix
% - It is eq.5.21 on the Barbero book
% - The matrix S is Q^-1
% 
% INPUTS
% - E1         : Youngs modulus on 1 direction
% - E2         : Youngs modulus on 2 direction
% - poison12   : Poison Ration on the 12 direction 
% - G12        : Shear modulus 1 direction
%
% OUTPUTS
% - Q : Matrix Q (eq.5.21)


function[Q] = COMPUTE_Q(E1,E2,poison12,G12)
    delta= 1 - (poison12^2)*E2/E1 ;
    
    Q(1,1) = E1/delta ;
    Q(2,2) = E2/delta ;
    Q(3,3) = G12 ;
    Q(1,2) = poison12 * E2 / delta;
    Q(2,1) = Q(1,2);
    Q(1,3) = 0;
    Q(2,3) = 0;
    Q(3,1) = 0;
    Q(3,2) = 0;
        
end