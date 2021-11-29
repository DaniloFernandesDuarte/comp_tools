% FUNCTION: COMPUTE a
% Written by: Danilo F. Duarte
% Started: 20/07/20
% Updated: 08/08/20 - Started code
%                   - Works as expected
% Updated: 19/01/21 - reviewed
%
% PURPOSE
% - Compute the matrix a whitch Relates laminate xy coordinates to 12
% - It is eq.5.40 on the Barbero book
% 
% INPUTS
% - theta         : angle between laminate and lamina
%
% OUTPUTS
% - T : Transformation Matrix a (eq.5.26)

function[a] = COMPUTE_A(theta)
    m = cosd(theta);
    n = sind(theta);
    a=[
        m , n ; 
        -n , m ;
      ];
end