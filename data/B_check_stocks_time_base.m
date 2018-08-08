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

function [stocks] = B_check_stocks_time_base(stocks)

    % determine stock with largest number of dates
    reference_stock = stocks(1);
    for i=1:1:numel(stocks)
        if numel(stocks(i).T) > numel(reference_stock.T)
            reference_stock = stocks(i);
        end
    end
    
    % iterate through each stock and check if dates are equal
    for i = numel(stocks) : -1 : 1
        
        comparison_stock = stocks(i);
        
        % determine index for comparison start
        idx_start = numel(reference_stock.T) - numel(comparison_stock.T) + 1;
        
        difference = abs(reference_stock.T(idx_start:end) - comparison_stock.T);

        % each date must be the same
        if sum(difference) ~= 0
            fprintf('Reference stock: %s   Comparison stock: %s\n', stocks(1).name, stocks(i).name);
            disp('Not the exact same dates with different history lengths.');
            disp('Deleting stock from list.');
            stocks(i) = [];
        end
    end
end
