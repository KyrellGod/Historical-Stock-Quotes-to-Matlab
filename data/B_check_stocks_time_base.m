% Stock data extraction
% Author: Kyrell God
% Date: 2018-08-07
% copyright (c) 2018 Kyrell God

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
