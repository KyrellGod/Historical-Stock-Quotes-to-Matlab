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

function [stocks_arrays_checked] = D_check_zeros(stocks_arrays)

    % We have to make sure that the stocks data does not randomly contain zeros.
    % This is a problem for non-US stocks only. If the market is closed in Germany but it is opened
    % in the US, Alpha Vantage still assumes values for Germany for this particular day - all zeros.
    
    % I'm not sure yet if the is a simple solution to this problem, therefore it's only a warning.
    
    % find all zeros in the opening values
    O_zeros_indices = find(stocks_arrays.O_array == 0.0);
    H_zeros_indices = find(stocks_arrays.H_array == 0.0);
    L_zeros_indices = find(stocks_arrays.L_array == 0.0);
    C_zeros_indices = find(stocks_arrays.C_array == 0.0);
    AC_zeros_indices = find(stocks_arrays.AC_array == 0.0);
    
    % Volume can be zero on some market days.
    % Dividens and splits are zero most of the time.
    
    if numel(O_zeros_indices) > 0
        warning('Stock data has zero opening values.')
    end    
    if numel(H_zeros_indices) > 0
        warning('Stock data has zero high values.');
    end    
    if numel(L_zeros_indices) > 0
        warning('Stock data has zero low values.');
    end    
    if numel(C_zeros_indices) > 0
        warning('Stock data has zero close values.');
    end    
    if numel(AC_zeros_indices) > 0
        warning('Stock data has zero adjusted close values.');
    end
    
    % the array stays the same for now
    stocks_arrays_checked = stocks_arrays;
end
