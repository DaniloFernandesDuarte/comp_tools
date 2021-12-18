clear;
close all;
clc;

pontos = [
    1	0	0	;
    2	30.091	40.55	;
    3	80.655	68.293	;
    4	155.198	93.117	;
    5	270	113.714	;
    6	370	119.724	; %
    7	470	116.254	;
    8	641.385	90.619	;
    9	721.466	71.17	;
    10	864.411	35.827	;
    11	1000	0	;
    12	864.411	5.248	;
    13	721.466	-13.344	;
    14	641.385	-28.958	;
    15	470	-58.689	;
    16	370	-64.007	; %
    17	270	-61.823	;
    18	155.198	-50.388	;
    19	80.655	-36.294	;
    20	30.091	-21.198	]

placas = [
    1, 2;
    2, 3;
    3, 4;
    4, 5;
    5, 6;
    6, 7;
    7, 8;
    8, 9;
    9, 10;
    10, 11;
    11, 12;
    12, 13;
    13, 14;
    14, 15;
    15, 16;
    16, 17;
    17, 18;
    18, 19;
    19, 20;
    20, 1;
    6, 16]

n = size(placas);
n = n(1);
i = 1;
b = zeros(n,1);
% Plotando os paineis

colorArray = ['#FF6633'; '#FFB399'; '#FF33FF'; '#FFFF99'; '#00B3E6'; 
		  '#E6B333'; '#3366E6'; '#999966'; '#99FF99'; '#B34D4D';
		  '#80B300'; '#809900'; '#E6B3B3'; '#6680B3'; '#66991A'; 
		  '#FF99E6'; '#CCFF1A'; '#FF1A66'; '#E6331A'; '#33FFCC';
		  '#66994D'; '#B366CC'; '#4D8000'; '#B33300'; '#CC80CC'; 
		  '#66664D'; '#991AFF'; '#E666FF'; '#4DB3FF'; '#1AB399';
		  '#E666B3'; '#33991A'; '#CC9999'; '#B3B31A'; '#00E680'; 
		  '#4D8066'; '#809980'; '#E6FF80'; '#1AFF33'; '#999933';
		  '#FF3380'; '#CCCC00'; '#66E64D'; '#4D80CC'; '#9900B3'; 
		  '#E64D66'; '#4DB380'; '#FF4D4D'; '#99E6E6'; '#6666FF'];

while i<=n
    x(i,1) = pontos(placas(i,1),2);
    y(i,1) = pontos(placas(i,1),3);
    x(i,2) = pontos(placas(i,2),2);
    y(i,2) = pontos(placas(i,2),3);
    plot(x(i,:),y(i,:),'Color', colorArray(i,:),'LineWidth',2); hold on   
    
    % Calculando as distâncias entre os pontos
    b(i) = sqrt( ((x(i,2)-x(i,1))^2 + (y(i,2)-y(i,1))^2 ));
    
    i = i + 1
end
% Plotando os pontos
plot(pontos(:,2),pontos(:,3),'o',...
    'MarkerSize',5,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','k')
axis equal
title("secção transversal") 
xlabel 'x [mm]'
ylabel 'y [mm]'


b

b; % define as larguras das CompositeSection;

