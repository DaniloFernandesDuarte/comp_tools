classdef CompositeSection2
    %CompositeSection Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        b
        EIxx
        EIyy
        EIxy
        
        RigidezAxial
        
        sigma_z_Bending
        
        test
    end
    
    properties (Access = private)
        % Define uma matriz de cores à ser usada para laminados diferentes
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
        
        x % coordenada x inicial e final [x0, x1]
        y % coordenada y inicial e final [y0, y1]
        xyPlacas % Centros das placas
        MechanicalCenter
        n % número de placas
        pontos % number, coord X, Coord Y
        placas % P0, p1, Mat
        laminados % [L1, L2 ... Ln]
        
        
        
    end
    
    methods
        function obj = CompositeSection2(pontos,placas,laminados)
            %CompositeSection Construct an instance of this class
            %   Detailed explanation goes here
            
            obj.pontos = pontos;
            obj.placas = placas;
            obj.laminados = laminados;
            
            obj.n = size(placas);
            obj.n = obj.n(1);
            i = 1;
            obj.b = zeros(obj.n,1);
            obj.xyPlacas = zeros(obj.n,2);
            
            while i<=obj.n
                % Definindo pontos da placa para facilitar a plotagem
                obj.x(i,1) = pontos(placas(i,1),1);
                obj.y(i,1) = pontos(placas(i,1),2);
                obj.x(i,2) = pontos(placas(i,2),1);
                obj.y(i,2) = pontos(placas(i,2),2);
                
                % Definindo centros das placas
                obj.xyPlacas(i,1) = (obj.x(i,2)+obj.x(i,1))/2;
                obj.xyPlacas(i,2) = (obj.y(i,2)+obj.y(i,1))/2;
                % Calculando as distâncias entre os pontos
                obj.b(i) = sqrt( ((obj.x(i,2)-obj.x(i,1))^2 + (obj.y(i,2)-obj.y(i,1))^2 ));

                i = i + 1;
            end
 
        end
        
        function PlotProfile(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            figure
            i=1;
            while i<=obj.n
                plot(obj.x(i,:),obj.y(i,:),'Color',...
                    obj.colorArray(obj.placas(i,3),:),'LineWidth',2); 
                hold on   
                i = i + 1;
            end
            % Plotando os pontos
            plot(obj.pontos(:,1),obj.pontos(:,2),'o',...
                'MarkerSize',5,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','k')
            axis equal
            title("secção transversal") 
            xlabel 'x [mm]'
            ylabel 'y [mm]'
            
        end   
    end
    
    methods (Access = private)
        
        
    end
    
    
end

