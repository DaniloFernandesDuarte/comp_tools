% FUNCTION: COMPUTE T
% Written by: Danilo F. Duarte
% Started: 20/07/20
% Updated: 08/08/20 - Started code
%                   - Works as expected
% Updated: 19/01/21 - reviewed
%
% PURPOSE
% - Compute the matrix T whitch Relates laminate deformation to the lamina
%   deformation
% - It is eq.5.40 on the Barbero book
% - Deformation_x = T * Deformation_1
% - Stress_x = T^-1 * Stress_1
% 
% INPUTS
% - theta : angle between laminate and lamina in degrees
%
% OUTPUTS
% - T     : Transformation Matrix T (eq.5.40)

function[T] = COMPUTE_T(theta)
    m = cosd(theta);
    n = sind(theta);
        
    T=[
        m^2  ,  n^2 , 2*m*n
        n^2  ,  m^2 , -2*m*n
        -m*n , m*n  , m^2 - n^2
      ];
end