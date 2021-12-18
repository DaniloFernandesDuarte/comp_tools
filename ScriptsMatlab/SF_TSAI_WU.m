% FUNCTION: COMPUTE Tsai-Wu safety factor for a composite lamina
% Written by: Danilo F. Duarte
% Started: 24/10/20
% Updated: 24/10/20 - Started code
%                   - Works as expected
% Updated: 19/01/21 - reviewed
%
% PURPOSE
% - Computing the safety factor for a composit lamina using the Tsai-Wu
% theory. 
% - Method discribed by Daniel's Engineering Mechanics of Composite
% Materials. Section 6.9
% 
% INPUTS
% - STRENGHT=[F1t,F1c,F2t,F2c,F6]'        Material strenght
% - TENSION=[sigma1,sigma2,sigma6]'       Tensions in the material axis
% OUTPUTS
% - Sfa = Actual state of stress
% - Sfr = Reversed in sign state of stress

function[Sfa, Sfr] = SF_TSAI_WU(STRENGHT,TENSION)
    
F1t = STRENGHT(1,1);
F1c = STRENGHT(2,1);
F2t = STRENGHT(3,1);
F2c = STRENGHT(4,1);
F6  = STRENGHT(5,1);

sigma1=TENSION(1,1);
sigma2=TENSION(2,1);
sigma6=TENSION(3,1);

% Tsai-wu polinomial coeficents
f1  = (1/F1t)-(1/F1c) ;
f11 = 1/(F1t*F1c) ;
f2  = (1/F2t)-(1/F2c) ;
f22 = 1/(F2t*F2c) ;
f66 = 1/(F6^2);
f12 = -(sqrt(f11*f22))/2;

% From equation 6.56 from Daniel's - Enginieering Mechanics of Composite
% Materials:
a = f11*(sigma1^2) + f22*(sigma2^2) + f66*(sigma6^2) + 2*f12*sigma1*sigma2;
b = f1*sigma1 + f2*sigma2 ;

% Actual state of stress
Sfa= (-b + sqrt(b^2 + 4*a))/(2*a) ;

% Reversed in sign state of stress
Sfr= (-b - sqrt((b^2) + 4*a))/(2*a) ;
end





