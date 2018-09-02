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

function [stocks_arrays] = provide_data(data_profile)

    disp('---------------------------------------');
    disp('Providing data ...');
    disp(' ');
    
    % extract data from profile
    date_start                  = data_profile.date_start;
    date_end                    = data_profile.date_end;
    stock_index                 = data_profile.stock_index;
    load_source                 = data_profile.load_source;
    load_specific_day           = data_profile.load_specific_day;
    load_specific_day_factor    = data_profile.load_specific_day_factor;
    debug_mode                  = data_profile.debug_mode;
    
    % extract raw data from file and shape data
    stocks          = A_extract_stocks_from_csv(stock_index, load_source);
    stocks          = B_check_stocks_time_base(stocks);
    stocks_arrays   = C_create_arrays(stocks);
    stocks_arrays   = D_check_zeros(stocks_arrays);
    stocks_arrays   = E_time_arrays(stocks_arrays, date_start, date_end, load_specific_day, load_specific_day_factor);
    
    % test random data points
    if debug_mode == true
        F_test_data(stocks_arrays);
    end
    
    disp(' ');
    disp('Done!');
    disp('---------------------------------------');
end