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
function F_test_data(stocks_arrays)

    % test some points
    while 1==1

        % pick a random stock
        random_stock_index = randi(size(stocks_arrays.O_array, 1));

        % next pick a random date
        random_date_index = randi(size(stocks_arrays.O_array, 2));  

        % show values so they can be compared with .csv files or the internet
        disp(' ');
        fprintf('symb: %s\n', stocks_arrays.symbols_vec{random_stock_index});
        fprintf('date: %f\n', stocks_arrays.T_vec(random_date_index));
        fprintf('date: %s\n', datestr(stocks_arrays.T_vec(random_date_index),'yyyy-mm-dd'));
        fprintf('O:    %f\n', stocks_arrays.O_array(random_stock_index,random_date_index));
        fprintf('H:    %f\n', stocks_arrays.H_array(random_stock_index,random_date_index));
        fprintf('L:    %f\n', stocks_arrays.L_array(random_stock_index,random_date_index));
        fprintf('C:    %f\n', stocks_arrays.C_array(random_stock_index,random_date_index));
        fprintf('AC:   %f\n', stocks_arrays.AC_array(random_stock_index,random_date_index));
        fprintf('V:    %f\n', stocks_arrays.V_array(random_stock_index,random_date_index));
        fprintf('D:    %f\n', stocks_arrays.D_array(random_stock_index,random_date_index));
        fprintf('S:    %f\n', stocks_arrays.S_array(random_stock_index,random_date_index));    

        % block
        disp(' ');
       	input('Press enter to show next value ...');
    end
end
