% FUNCTION: COMPUTE Tsai-Wu safety factor for a composite lamina
% Written by: Danilo F. Duarte
% Started: 24/10/20
% Updated: 24/10/20 - Started code
%                   - Works as expected
% Updated: 19/01/21 - reviewed
%
% PURPOSE
% - Computing the safety factor for a composit lamina using the
%   Hashin-Rotem theory. 
% - Method discribed by Daniel's Engineering Mechanics of Composite
% Materials. Section 6.9
% 
% INPUTS
% - STRENGHT=[F1t,F1c,F2t,F2c,F6]'        Material strenght
% - TENSION=[sigma1,sigma2,sigma6]'       Tensions in the material axis
% OUTPUTS
% - fiber_fail  = Fiber safety factor
% - matrix_fail = Matrix safety factor

function[fiber_fail, matrix_fail] = SF_HASHIN_ROTEM(STRENGHT,TENSION)
    
F1t = STRENGHT(1,1);
F1c = STRENGHT(2,1);
F2t = STRENGHT(3,1);
F2c = STRENGHT(4,1);
F6  = STRENGHT(5,1);

sigma1=TENSION(1,1);
sigma2=TENSION(2,1);
sigma6=TENSION(3,1);

% Strengh coeficents
% Seting strengh coeficents to correspond to the tension state
if sigma1>0
    F1=F1t;
else
    F1=F1c;
end

if sigma2>0
    F2=F2t;
else
    F2=F2c;
end

% From equation 6.49 from Daniels - Enginieering Mechanics of Composite
% Materials:

% Fiber failure
fiber_fail= abs(sigma1)/F1;

% Matrix failure
matrix_fail= (((abs(sigma2/F2))^2) + ((sigma6/F6)^2)); 

end





