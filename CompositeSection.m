classdef CompositeSection
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
        function obj = CompositeSection(pontos,placas,laminados)
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
            
%             % Calculos de rigidez estrutural
%             % Calculando a rigidez axial da secção
%             obj.RigidezAxial = 0;
%             i=1;
%             while i<=obj.n
%                 L = obj.placas(i,3); % definindo o laminado a ser somado         
%                 obj.RigidezAxial = obj.RigidezAxial + obj.b(i)*obj.laminados(L).t*...
%                                 obj.laminados(L).Exm; % megson eq 25.65
%                 % Rigidez à flexão
%                 obj.EIxx = 0;
%                 obj.EIyy = 0;
%                 obj.EIxy = 0;
%                 
%                 % EIxx ou I'xx eq 25,67 do megson
%                 obj.EIxx = obj.EIxx + obj.laminados(L).Exm*obj.xyPlacas(i,2)^2*...
%                     obj.b(i)*obj.laminados(L).t*obj.b(i);
%                 % EIyy ou I'yy eq 25,67 do megson
%                 obj.EIyy = obj.EIyy + obj.laminados(L).Exm*obj.xyPlacas(i,1)^2*...
%                     obj.b(i)*obj.laminados(L).t*obj.b(i);
%                 % EIxy ou I'xy eq 25,67 do megson
%                 obj.EIxy = obj.EIxy + obj.laminados(L).Exm*obj.xyPlacas(i,1)*obj.xyPlacas(i,2)*...
%                     obj.b(i)*obj.laminados(L).t*obj.b(i);   
%                 i = i+1;
%             end
% %             obj.xyPlacas
%             % Rigidez à flexão
%             % EIxx ou I'xx eq 25,26 do megson
            
%             testar_m = testMethod(1)

            
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
        
%         function obj = BendingTension(obj,Mx,My)
%         % BendingTension Compute the tension sigma_z causeb by moments
%         % The moments are Mx and My and will be computed for every point
%         
%         obj.sigma_z_Bending = zeros(obj.n,1);
%             for i = 1:obj.n
%                 % x = obj.xyPlacas(i,1);
%                 % y = obj.xyPlacas(i,2);
%                 i
%                 mat = obj.placas(i,3)
%                 E_zi = obj.laminados(mat).Exm
% 
%                 obj.sigma_z_Bending(i) = E_zi * ...
%                     (...
%                 ((My*obj.EIxx - Mx*obj.EIxy)/(obj.EIxx*obj.EIyy - obj.EIxy^2))*obj.xyPlacas(i,1) + ...
%                 ((Mx*obj.EIyy - My*obj.EIxy)/(obj.EIxx*obj.EIyy - obj.EIxy^2))*obj.xyPlacas(i,2) ...
%                     );
%                 
%                 obj.EIxx
%                 obj.EIyy
%                 obj.EIxy
% %                 (My*obj.EIxx - Mx*obj.EIxy)
% %                 (obj.EIxx*obj.EIyy - obj.EIxy^2)
% %                 obj.xyPlacas(i,1)
%                 
%                 pqp = obj.sigma_z_Bending(i)
%             end
%         end
        
        function [] = rigidezViga(obj)

        end
        
    end
end

