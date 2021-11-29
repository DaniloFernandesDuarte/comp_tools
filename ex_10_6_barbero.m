
% Example 10.5, ISBN 1420079159

clear
clc

YZ = [20 0;0 0; 0 20.001]; % nodal coordinates
conect = [1 2 0;2 3 1];    % segment connectivity and contributions
ti = [2 2]; %mm
Ei = [1 1]*210E3; %MPa
nui = [.3 .3];


viga = BarberoSection(YZ,conect,ti,Ei,nui)
