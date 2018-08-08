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

clear all;
close all;

% some init settings
addpath('data');

% load all data
data_profile.date_start                 = datenum('1000-03-01', 'yyyy-mm-dd');
data_profile.date_end                   = datenum('3000-01-01', 'yyyy-mm-dd');
data_profile.stock_index                = 'nasdaq100';
data_profile.load_source                = 'load_csv';
data_profile.load_specific_day          = 'every day';
data_profile.load_specific_day_factor   = 1;
data_profile.debug_mode                 = false;
[stocks_arrays_all_days] = provide_data(data_profile);


%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%   After running Example 1 the script will create a .mat file. This will be used in Example 2.
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


% Example 2: Read each second Monday starting at date closest to September 13, 2010. Read from .mat file.

data_profile.date_start                 = datenum('2010-09-13', 'yyyy-mm-dd');
data_profile.date_end                   = datenum('3000-01-01', 'yyyy-mm-dd');
data_profile.stock_index                = 'nasdaq100';
data_profile.load_source                = 'load_mat';
data_profile.load_specific_day          = 'Mon';
data_profile.load_specific_day_factor   = 2;
data_profile.debug_mode                 = false;
[stocks_arrays_2nd_monday] = provide_data(data_profile);
