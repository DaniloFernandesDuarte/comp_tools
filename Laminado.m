classdef Laminado
    % Laminado Uma classe utilizada para compactar propriedades de laminados
    % ABD = ABD Matrix
    % H   = Transverseshear stiffness
    % S = sum(X,DIM) sums "X" along the dimension "DIM".
    % A: Extensional stiffness matrix A
    % Bending extension coupling stiffness matrix B
    % Bending stiffness matrix D
    % H: Transverse shear stiffness
    
    properties
        ABD; % ABD Matrix
        abd; % The inverse of the ABD Matrix
        L; % Laminado: [Material, orientação, espessura, posição em relação ao centro]
        Q; % Matriz Q de todas as lâminas 
        H; % Transverse shear stiffness
        QT;% Matriz Q transformada de todas as lâminas 
        
        t; % Espessura do laminado
        n; % Número de lâminas
        STRENGHT; %STRENGH=[F1t,F1c,F2t,F2c,F6]';
        
     end
    
    properties
        deformacao_in;
        deformacao_out;
        
        deff_xy
        deff_12
        stress_12
        stress
        
        max_stress_sf
        tsai_wu_sf
        hashin_rotem_sf
        
        S_moduli
                
        Exm
        Eym
        vxym
        Gxym
        Gyzm
        Gxzm
        
        abd_reduced
        ABD_reduced
        
        
    end
    
    properties (Access = private)
        % The reuter matrix is used to transform the dformations as given by
        % eq.5.42: {exy}=[R][T]inv[R]{e12}
        reuter = [ 1 , 0 , 0  ;
                   0 , 1 , 0  ;
                   0 , 0 , 2 ];
        % From Barbeiro's equation 6.7
        
        abdr % from eq 10.19
        ABDr % from eq 10.20
    end
%%
    methods
        function obj = Laminado(L)
            % Define ABD, abd, H, L, Q, STRENGHT, n, t 
            %   Detailed explanation goes here
            [obj.L,obj.Q,obj.ABD,obj.H,obj.QT]=COMPUTE_ABD(L);
            obj.abd = inv(obj.ABD);
           
            % Número de laminas
            obj.n = size(L,1);
            
            if obj.n > 1
                soma = sum(L);
                obj.t = soma(3);
            else
                obj.t = L(3);
            end
            clear soma sizeL;
            
            % Definindo as resistências das lâminas
            i=1;
            while i<=obj.n
                %[PHYSICAL,MECHANICAL,STRENGHT(:,:,i)] = COMPOSITE_LIST_V02(L(i,1));
                [~,~,obj.STRENGHT(:,:,i)] = COMPOSITE_LIST_V02(L(i,1)); 
                i=i+1;
            end
            % Definindo os modulos do laminado
            obj.S_moduli = LAMINATE_MODULI_S(obj.ABD,obj.H,obj.t);
            [obj.Exm,obj.Eym,obj.vxym,obj.Gxym,obj.Gyzm,obj.Gxzm] = LAMINATE_MODULI_BULK(obj.ABD,obj.H,obj.t);
            
            
            % Matriz reduzida de propriedades (eq 10.19 e 10.20)
            obj.abd_reduced = [
                 obj.abd(1,1), obj.abd(1,4), 0, 0;
                 obj.abd(1,4), obj.abd(4,4), 0, 0
                 0, 0, obj.abd(3,3), obj.abd(3,6);
                 0, 0, obj.abd(3,6), obj.abd(6,6);];
            
            obj.ABD_reduced = inv(obj.abd_reduced);
        end
    end
    
    methods
        %% Calculando deformações e fatores de segurança
        function obj = force_in(obj,F_in)
            % deformacao_in Calculo das deformacoes no plano
            %   Detailed explanation goes here
            obj.deformacao_in = obj.abd * F_in;

            % Computando as deformações e tensões das lâminas individuais 
            % The reuter matrix is used to transform the dformations as given by
            % eq.5.42: {exy}=[R][T]inv[R]{e12}
            % From Barbeiro's equation 6.7
            i=1;
            while i<=obj.n
                % Deformação na direção do laminado
                obj.deff_xy(:,:,i) = obj.deformacao_in(1:3,1) - obj.L(i,4)*obj.deformacao_in(4:end,1);
                % Deformação na direção das lâminas, eq.5.42
                obj.deff_12(:,:,i) = obj.reuter * COMPUTE_T(obj.L(i,2)) * inv(obj.reuter) * obj.deff_xy(:,:,i);
                % Stresses nas direções das lâminas
                obj.stress_12(:,:,i) = obj.Q(:,:,i) * obj.deff_12(:,:,i); 
                obj.stress(:,i)=obj.stress_12(:,:,i);
                i=i+1;
            end
            
            % Calculando os fatores de segurança das lâminas 
            %  STRENGH=[F1t,F1c,F2t,F2c,F6]';
            i=1;
            while i<=obj.n
                % Max stress method
                % - R = [R1,R2,R6]      Strengh ratio in the directions 1, 2, 6
                [R] = SF_MAX_STRESS(obj.STRENGHT(:,:,i),obj.stress_12(:,:,i)); 
                obj.max_stress_sf(:,i) = [R];
                % Tsai-Wu method
                % - Sfa = Actual state of stress
                % - Sfr = Reversed in sign state of stress
                [Sfa, Sfr] = SF_TSAI_WU(obj.STRENGHT(:,:,i),obj.stress_12(:,:,i)); 
                obj.tsai_wu_sf(:,i) = [Sfa, Sfr]';
                % Hashin Rotem method
                % - fiber_fail  = Fiber safety factor
                % - matrix_fail = Matrix safety factor
                [fiber_fail, matrix_fail] = SF_HASHIN_ROTEM(obj.STRENGHT(:,:,i),...
                                            obj.stress_12(:,:,i)); 
                obj.hashin_rotem_sf(:,i)=[1./fiber_fail, 1./matrix_fail]';  
                i=i+1;    
            end

        end
        
        function obj = force_out(obj,F_out)
            % deformacao_in: calculo das deformacoes no plano
            %   Detailed explanation goes here
            compute_deformacao_out = inv(obj.H) * F_out ;
            obj.deformacao_out  = compute_deformacao_out;
        end
        
    end
    

    
end

