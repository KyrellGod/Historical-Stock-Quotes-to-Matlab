% Stock data extraction
% Author: Kyrell God
% Date: 2018-08-07
% copyright (c) 2018 Kyrell God

function [stocks_arrays] = provide_data(data_profile)

%
% Extracts financial data from .csv files downloaded from https://www.alphavantage.co/.
%
% You can download financial data from alphavantage into .csv files. This script helps you
% importing this data into matlab for offline processing.
%
%
% Arguments are put into the structure 'data_profile':
%
%   data_profile.date_start             	Data extracting starts with date closest to date_start.
%   data_profile.date_end               	Data extracting ends with date closest to date_end.
% 	data_profile.stock_index             	Name of subfolder where .csv files are located.
% 	data_profile.load_source                'load_csv': Read all .csv file, then save all data in .mat file.
%                                           'load_mat': Read the .mat file only. Quicker.
% 	data_profile.load_specific_day          'every day', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'
% 	data_profile.load_specific_day_factor   Any positive integer number starting with 1.           
%	data_profile.debug_mode                 false or true. If true, data from random dates will be shown.
%
%
% Example 1: Read all data from the nasdaq100 subfolder. Each .csv is read.
%
%   data_profile.date_start                 = datenum('1000-03-01', 'yyyy-mm-dd');
%   data_profile.date_end                   = datenum('3000-01-01', 'yyyy-mm-dd');
%   data_profile.stock_index                = 'nasdaq100';
%   data_profile.load_source                = 'load_csv';
%   data_profile.load_specific_day          = 'every day';
%   data_profile.load_specific_day_factor   = 1;
%   data_profile.debug_mode                 = false;
%   [stocks_arrays_all_days] = provide_data(data_profile);
%
%
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%   After running Example 1 the script will create a .mat file. This will be used in Example 2.
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%
%
% Example 2: Read each second Monday starting at date closest to September 13, 2010. Read from .mat file.
%
%   data_profile.date_start                 = datenum('2010-09-13', 'yyyy-mm-dd');
%   data_profile.date_end                   = datenum('3000-01-01', 'yyyy-mm-dd');
%   data_profile.stock_index                = 'nasdaq100';
%   data_profile.load_source                = 'load_mat';
%   data_profile.load_specific_day          = 'Mon';
%   data_profile.load_specific_day_factor   = 2;
%   data_profile.debug_mode                 = false;
%   [stocks_arrays_2nd_monday] = provide_data(data_profile);
%

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
    stocks_arrays   = D_time_arrays(stocks_arrays, date_start, date_end, load_specific_day, load_specific_day_factor);
    
    % test random data points
    if debug_mode == true
        E_test_data(stocks_arrays);
    end
    
    disp(' ');
    disp('Done!');
    disp('---------------------------------------');
end