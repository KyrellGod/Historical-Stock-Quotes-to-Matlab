% Stock data extraction
% Author: Kyrell God
% Date: 2018-08-07
% copyright (c) 2018 Kyrell God

function [stocks_arrays] = C_create_arrays(stocks)

    % first find the stock with the longest history (might be more than one with the same length)
    reference_stock = stocks(1);
    for i=1:1:numel(stocks)
        if numel(stocks(i).T) > numel(reference_stock.T)
            reference_stock = stocks(i);
        end
    end
    
    % create the data arrays with the length of the reference stock
    stocks_arrays.symbols_vec   = cell(numel(stocks),1);
    stocks_arrays.T_vec         = reference_stock.T';
    stocks_arrays.T_idx         = 1:1:numel(stocks_arrays.T_vec)';
    stocks_arrays.O_array       = ones(numel(stocks), numel(stocks_arrays.T_vec))*NaN;
    stocks_arrays.H_array       = ones(numel(stocks), numel(stocks_arrays.T_vec))*NaN;
    stocks_arrays.L_array       = ones(numel(stocks), numel(stocks_arrays.T_vec))*NaN;
    stocks_arrays.C_array       = ones(numel(stocks), numel(stocks_arrays.T_vec))*NaN;
    stocks_arrays.AC_array      = ones(numel(stocks), numel(stocks_arrays.T_vec))*NaN;
    stocks_arrays.V_array       = ones(numel(stocks), numel(stocks_arrays.T_vec))*NaN;
    stocks_arrays.D_array       = ones(numel(stocks), numel(stocks_arrays.T_vec))*NaN;
    stocks_arrays.S_array       = ones(numel(stocks), numel(stocks_arrays.T_vec))*NaN;

    % extract all prices of each stock, non-existing values are filled with dummy values
    for i = 1:1:numel(stocks)
        
        % write symbols
        stocks_arrays.symbols_vec{i} = stocks(i).name;
        
        % write other data
        this_stocks_O = stocks(i).O;
        this_stocks_H = stocks(i).H;
        this_stocks_L = stocks(i).L;
        this_stocks_C = stocks(i).C;
        this_stocks_AC = stocks(i).AC;
        this_stocks_V = stocks(i).V;
        this_stocks_D = stocks(i).D;
        this_stocks_S = stocks(i).S;
        
        % in case we do not have the same number of dates
        offset = numel(stocks_arrays.T_vec) - numel(stocks(i).T) + 1;
        
        % write data into correct position
        stocks_arrays.O_array(i,offset:end) = this_stocks_O;
        stocks_arrays.H_array(i,offset:end) = this_stocks_H;
        stocks_arrays.L_array(i,offset:end) = this_stocks_L;
        stocks_arrays.C_array(i,offset:end) = this_stocks_C;
        stocks_arrays.AC_array(i,offset:end) = this_stocks_AC;
        stocks_arrays.V_array(i,offset:end) = this_stocks_V;
        stocks_arrays.D_array(i,offset:end) = this_stocks_D;
        stocks_arrays.S_array(i,offset:end) = this_stocks_S;
    end
end

