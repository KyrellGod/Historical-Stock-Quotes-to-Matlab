% Stock data extraction
% Author: Kyrell God
% Date: 2018-08-07
% copyright (c) 2018 Kyrell God

function E_test_data(stocks_arrays)

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
