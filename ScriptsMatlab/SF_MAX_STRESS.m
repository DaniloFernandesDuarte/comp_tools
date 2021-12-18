% FUNCTION: COMPUTE Tsai-Wu safety factor for a composite lamina
% Written by: Danilo F. Duarte
% Started: 24/10/20
% Updated: 24/10/20 - Started code
%                   - Works as expected
% Updated: 19/01/21 - reviewed
%
% PURPOSE
% - Computing the safety factor for a composit lamina using the maximum 
% stress method 
% - Method discribed by Daniel's Engineering Mechanics of Composite
% Materials. chapter 6
% 
% INPUTS
% - STRENGHT=[F1t,F1c,F2t,F2c,F6]'        Material strenght
% - TENSION=[sigma1,sigma2,sigma6]'       Tensions in the material axis
% OUTPUTS
% - R = [R1,R2,R6]      Strengh ratio in the directions 1, 2, 6


function[R] = SF_MAX_STRESS(STRENGHT,TENSION)
    
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

R(1,1)= F1/abs(sigma1);    
R(2,1) = F2/abs(sigma2);
R(3,1) = F6/abs(sigma6);

precision=0.00001;
error_number=999.9999;
if precision > 1/R(1,1)
    R(1,1)=error_number;
end
if precision > 1/R(2,1)
    R(2,1)=error_number;
end
if precision > 1/R(3,1)
    R(3,1)=error_number;
end

end





