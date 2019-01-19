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

function [stocks_raw] = A_extract_stocks_from_csv(stock_index, source)

    if strcmp(source, 'load_csv')
        
        % determine directory depending on stock index
        if strcmp(stock_index, 'nasdaq100')
            directory = 'data/nasdaq100/';
        elseif strcmp(stock_index, 'sp500')
            directory = 'data/sp500/';
        else
            error('Unknown stock index!');        
        end

        % extract all file names in directory
        listing = dir(directory);

        % container for raw stock data
        stocks_raw = [];

        % delete the first two files "." and ".."    
        listing(2) = [];
        listing(1) = [];

        % extract all data from files
        cnt_disp = 1;
        for i=1:1:numel(listing)

            % show progress
            fprintf('%d ', floor((100*(i-1))/numel(listing)));
            cnt_disp = cnt_disp + 1;
            if cnt_disp > 20
                cnt_disp = 0;
                fprintf('\n');
            end

            % create filepath
            [~, stock_name, extension] = fileparts(listing(i).name);
            filepath = strcat(directory, stock_name, extension);

            % open file
            fileID = fopen(filepath);

            % how many lines have to be skipped
            skip_lines = 1;

            % read all as string -> eight values comma separated
            C0 = textscan(fileID,'%s %s %s %s %s %s %s %s %s','Delimiter',',','Headerlines',skip_lines);

            % close file
            fclose(fileID);

            % convert to cell with correct dimensions
            C1 = [C0{:}];

            % A date is always given, but the rest can be 'null'.
            % Delete those lines with 'null'.
            % We beginn at the latest date.
            % YAHOO.com puts null in the csv.file.
            C1(strcmp(C1(:, 2),'null'), :)= [];

            % extract all data
            date        = datenum(C1(:,1),'yyyy-mm-dd');
            open        = cellfun(@str2num,C1(:,2));
            high        = cellfun(@str2num,C1(:,3));
            low         = cellfun(@str2num,C1(:,4));
            close       = cellfun(@str2num,C1(:,5));
            adj_close   = cellfun(@str2num,C1(:,6));
            volume      = cellfun(@str2num,C1(:,7));
            dividend    = cellfun(@str2num,C1(:,8));
            split       = cellfun(@str2num,C1(:,9));

            % create output array
            output = [date, open, high, low, close, adj_close, volume, dividend, split];

            % alpha anvantage puts the latest date on top, so change order
            output = flipud(output);
            
            % convert data to stock instance
            stock_new = stock(  stock_name, ...
                                output(:,1),...
                                output(:,2),...
                                output(:,3),...
                                output(:,4),...
                                output(:,5),...
                                output(:,6),...
                                output(:,7),...
                                output(:,8),...
                                output(:,9));
            stocks_raw = [stocks_raw; stock_new];
        end
        
        % save file
        filename = strcat('stocks_raw_full_data_',stock_index,'.mat');
        save(filename, 'stocks_raw');
        
    elseif strcmp(source, 'load_mat')
        
        filename = strcat('stocks_raw_full_data_',stock_index,'.mat');
        load(filename, 'stocks_raw');
        
    end
end

