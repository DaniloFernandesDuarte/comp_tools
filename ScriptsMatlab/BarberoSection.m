classdef BarberoSection
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        YZ  % nodal coordinates
        conect % segment connectivity and contributions
        ti %mm
        Ei %MPa
        nui
        
        nn %# of nodes
        ns %# of segments
        Gi
        
        no %initial node for segment i
        nf %final node
        dY 
        dZ 
        bi %length of segment
        alphai %angle of segment
        yi_ %centroid of each segment
        zi_
        
        test
    end
    
    properties (Access = public ) % private
        Ai  %extension
        Bi %coupling
        ebi %neutral axis of bending for the segment
        Di  %bending
        Di_ %shifted to neutral axis of bending
        Fi
        Ci 
        Hi
        eqi 
        Hi_  %shifted to neutral axis of torsion
        EIsi %bending stiffness of segment
        EIri 
        EIsri %mechanical product of inertia
        
        
        m 
        n 
        EIyi 
        EIzi 
        EIyzi 

        EA  
        GJR 
        EQy 
        EQz 

        yG_ 
        zG_ 

        yi 
        zi 

        EIyy 
        EIzz 
        EIyz 

        theta %1st ed.

        EInn 
        EIqq 
    end
    
    methods
        function obj = BarberoSection(YZ,conect,ti,Ei,nui)
            %UNTITLED4 Construct an instance of this class
            %   Detailed explanation goes here
            
            obj.YZ=YZ;  % nodal coordinates
            obj.conect=conect; % segment connectivity and contributions
            obj.ti=ti; %mm
            obj.Ei=Ei; %MPa
            obj.nui=nui;
            
            obj.nn = length(YZ(:,1));      %# of nodes
            obj.ns = length(conect(:,1));  %# of segments
            obj.Gi = Ei/2./(1+nui);
            
            % Definindo propriedades da secção 
            obj = obj.computeGeometryProperties;
            obj = obj.computeMechanicalPropertiesForPlates;
            obj = obj.computeMechanicalPropertiesForBeam;
        end
        
        function obj = computeGeometryProperties(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here  
            for i = 1:obj.ns    %for each segment
                obj.no = obj.conect(i,1); %initial node for segment i
                obj.nf = obj.conect(i,2); %final node
                obj.dY = obj.YZ(obj.nf,1)-obj.YZ(obj.no,1);
                obj.dZ = obj.YZ(obj.nf,2)-obj.YZ(obj.no,2);
                obj.bi(i) = ((obj.dY)^2+(obj.dZ)^2)^(1/2);  %length of segment
                obj.alphai(i) = atan(obj.dZ/obj.dY);        %angle of segment
                obj.yi_(i) = (obj.YZ(obj.no,1)+obj.YZ(obj.nf,1))/2; %centroid of each segment
                obj.zi_(i) = (obj.YZ(obj.no,2)+obj.YZ(obj.nf,2))/2;
            end
        end
        
        function obj = computeMechanicalPropertiesForPlates(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here  
            obj.Ai = obj.Ei.*obj.ti;     %extension
            obj.Bi = [0 0] ;     %coupling
            obj.ebi = obj.Bi./obj.Ai;    %neutral axis of bending for the segment
            obj.Di = obj.Ei.*obj.ti.^3/12;   %bending
            obj.Di_ = obj.Di-obj.ebi.^2.*obj.Ai; %shifted to neutral axis of bending
            obj.Fi = obj.Gi.*obj.ti;
            obj.Ci = [0 0];
            obj.Hi = obj.Gi.*obj.ti.^3/12;
            obj.eqi = obj.Ci./obj.Fi;
            obj.Hi_ = obj.Hi-obj.eqi.^2.*obj.Ci; %shifted to neutral axis of torsion
            obj.EIsi = obj.Di_.*obj.bi;      %bending stiffness of segment
            obj.EIri = obj.Ai.*obj.bi.^3/12;
            obj.EIsri = [0 0];       %mechanical product of inertia
        end
        
        function obj = computeMechanicalPropertiesForBeam(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here  
            obj.m = cos(obj.alphai);
            obj.n = sin(obj.alphai);
            obj.EIyi = obj.m.^2.*obj.EIsi + obj.n.^2.*obj.EIri;
            obj.EIzi = obj.n.^2.*obj.EIsi + obj.m.^2.*obj.EIri;
            obj.EIyzi = (obj.EIri-obj.EIsi).*obj.m.*obj.n; %1st ed.

            obj.EA  = sum(obj.Ai.*obj.bi);
            obj.GJR = 4*sum(obj.Hi_.*obj.bi);
            obj.EQy = sum(obj.zi_.*obj.Ai.*obj.bi);
            obj.EQz = sum(obj.yi_.*obj.Ai.*obj.bi);

            obj.yG_ = obj.EQz/obj.EA;
            obj.zG_ = obj.EQy/obj.EA;

            obj.yi = obj.yi_-obj.yG_;
            obj.zi = obj.zi_-obj.zG_;

            obj.EIyy = sum(obj.EIyi+obj.Ai.*obj.bi.*(obj.zi+obj.ebi.*obj.m).^2);
            obj.EIzz = sum(obj.EIzi+obj.Ai.*obj.bi.*(obj.yi-obj.ebi.*obj.n).^2);
            obj.EIyz = sum(obj.EIyzi+obj.Ai.*obj.bi.*(obj.zi+obj.ebi.*obj.m).*(obj.yi-obj.ebi.*obj.n));

            obj.theta = 1/2*atan(2*obj.EIyz/(obj.EIzz-obj.EIyy)); %1st ed.
            disp(['theta ',num2str(obj.theta*180/pi)])
            obj.EInn = 1/2*(obj.EIyy+obj.EIzz) + sqrt((obj.EIyy-obj.EIzz)^2/4+obj.EIyz^2);
            obj.EIqq = 1/2*(obj.EIyy+obj.EIzz) - sqrt((obj.EIyy-obj.EIzz)^2/4+obj.EIyz^2);
        end 
        
    end
end

