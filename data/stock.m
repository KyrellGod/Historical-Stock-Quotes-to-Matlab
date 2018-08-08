%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

classdef stock < handle

    properties
        name;
        T;
        O;
        H;
        L;
        C;
        AC;
        V;
        D;
        S;
        
        % for quick access
        date_latest;
        date_oldest;
        
        % performance array for external access
        performance;
    end
    
    methods (Static = true, Access = public)
        
        % constructor
        function obj = stock(name_arg, T_raw, O_raw, H_raw, L_raw, C_raw, AC_raw, V_raw, D_raw, S_raw)
            obj.name = name_arg;
            obj.T   = T_raw;
            obj.O   = O_raw;
            obj.H   = H_raw;
            obj.L   = L_raw;
            obj.C   = C_raw;
            obj.AC  = AC_raw;
            obj.V   = V_raw;
            obj.D   = D_raw;
            obj.S   = S_raw;
            
            obj.performance = [];
                        
            obj.check_validity();
        end
        
    end
    
    methods (Static = false, Access = public)
        
        function check_validity(self)
            
            % check if all arrays have the same length
            reference = numel(self.T);
            if reference ~= numel(self.O)
                error('numel(T) != numel(O)');
            elseif reference ~= numel(self.H)
                error('numel(T) != numel(H)');
            elseif reference ~= numel(self.L)
                error('numel(T) != numel(L)');
            elseif reference ~= numel(self.C)
                error('numel(T) != numel(C)');
            elseif reference ~= numel(self.AC)
                error('numel(T) != numel(AC)');                
            elseif reference ~= numel(self.V)
                error('numel(T) != numel(V)');
            elseif reference ~= numel(self.D)
                error('numel(T) != numel(D)');
            elseif reference ~= numel(self.S)
                error('numel(T) != numel(S)');                
            end
            
            % extract latest and oldest dates
            [self.date_latest, idx_latest] = max(self.T);
            [self.date_oldest, idx_oldest] = min(self.T);            
            
            % check latest and oldest date
            if idx_latest ~= numel(self.T)
                fprinft('Stock name: %s\n', self.name);
                error('Latest date is not the length of the time array.');
            end
            if idx_oldest ~= 1
                fprinft('Stock name: %s\n', self.name);
                error('Oldest date has not index 1.');
            end            
        end        
    end
end