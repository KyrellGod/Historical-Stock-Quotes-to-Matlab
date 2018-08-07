% Stock data extraction
% Author: Kyrell God
% Date: 2018-08-07
% copyright (c) 2018 Kyrell God

% date_start is a number
function [stocks_arrays] = D_time_arrays(stocks_arrays, date_start, date_end, load_specific_day, load_specific_day_factor)

    % find the date closest to date_start
    [~, min_idx] = min(abs(stocks_arrays.T_vec - date_start));
    
    % delete all dates before min_idx    
    stocks_arrays.T_vec = stocks_arrays.T_vec(min_idx:end);
    stocks_arrays.T_idx = stocks_arrays.T_idx(min_idx:end);
    stocks_arrays.O_array = stocks_arrays.O_array(:, min_idx:end);
    stocks_arrays.H_array = stocks_arrays.H_array(:, min_idx:end);
    stocks_arrays.L_array = stocks_arrays.L_array(:, min_idx:end);
    stocks_arrays.C_array = stocks_arrays.C_array(:, min_idx:end);
    stocks_arrays.AC_array = stocks_arrays.AC_array(:, min_idx:end);
    stocks_arrays.V_array = stocks_arrays.V_array(:, min_idx:end);
    stocks_arrays.D_array = stocks_arrays.D_array(:, min_idx:end);
    stocks_arrays.S_array = stocks_arrays.S_array(:, min_idx:end);
    
    % find the date closest to date_end
    [~, min_idx] = min(abs(stocks_arrays.T_vec - date_end));
    
    % delete all dates before min_idx
    stocks_arrays.T_vec = stocks_arrays.T_vec(1:min_idx);
    stocks_arrays.T_idx = stocks_arrays.T_idx(1:min_idx);
    stocks_arrays.O_array = stocks_arrays.O_array(:, 1:min_idx);
    stocks_arrays.H_array = stocks_arrays.H_array(:, 1:min_idx);
    stocks_arrays.L_array = stocks_arrays.L_array(:, 1:min_idx);
    stocks_arrays.C_array = stocks_arrays.C_array(:, 1:min_idx);
    stocks_arrays.AC_array = stocks_arrays.AC_array(:, 1:min_idx);
    stocks_arrays.V_array = stocks_arrays.V_array(:, 1:min_idx);
    stocks_arrays.D_array = stocks_arrays.D_array(:, 1:min_idx);
    stocks_arrays.S_array = stocks_arrays.S_array(:, 1:min_idx);    
    
    % extract every day
    if strcmp(load_specific_day, 'every day')
        
        idx_of_days = 1:1:numel(stocks_arrays.T_vec);
        
    % extract specific day of the week
    elseif strcmp(load_specific_day, 'Mon') || strcmp(load_specific_day, 'Tue') || ...
            strcmp(load_specific_day, 'Wed') || strcmp(load_specific_day, 'Thu') || ...
            strcmp(load_specific_day, 'Fri')
   
        [~,days_str] = weekday(stocks_arrays.T_vec);
        days_str = cellstr(days_str);
        idx_of_days = find(strcmp(days_str, load_specific_day));
         
    % undefined day type
    else        
        error('Unknown day specification.');        
    end
    
    % divide by the factor
    idx_of_days = idx_of_days(1 : load_specific_day_factor : end);
            
    % only extract those dates that we are interested in
    stocks_arrays.T_vec = stocks_arrays.T_vec(idx_of_days);
    stocks_arrays.T_idx = stocks_arrays.T_idx(idx_of_days);
    stocks_arrays.O_array = stocks_arrays.O_array(:, idx_of_days);
    stocks_arrays.H_array = stocks_arrays.H_array(:, idx_of_days);
    stocks_arrays.L_array = stocks_arrays.L_array(:, idx_of_days);
    stocks_arrays.C_array = stocks_arrays.C_array(:, idx_of_days);
    stocks_arrays.AC_array = stocks_arrays.AC_array(:, idx_of_days);
    stocks_arrays.V_array = stocks_arrays.V_array(:, idx_of_days);
    stocks_arrays.D_array = stocks_arrays.D_array(:, idx_of_days);
    stocks_arrays.S_array = stocks_arrays.S_array(:, idx_of_days);
end
