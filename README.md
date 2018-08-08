# Historical-Stock-Quotes-to-Matlab

This repo contains software which you can use to download historical stock quotes into .csv files and then import these files into Matlab for offline processing. The source for the stock quotes is ALPHA VANTAGE since Yahoo finance and Google finance have shut down their services.

## How to use it

There are two steps you have to follow.

### 1. Download data from Alpha Vantage into .csv files

Open a terminal and run the script *data_download.sh*. It will take several minutes to download all .csv files.
```bash
./data_download.sh -i nasdaq100
```
You can also download stock quotes for the german TecDAX.
```bash
./data_download.sh -i tecdax
```
In both cases the script will create a new folder and put all .csv files into it. Also, it will create a compressed version of this folder.

If you want to download another index (e.g. Dow Jones, DAX) you will have to add the stock symbols to the script yourself. Also, if the components of the nasdaq100 are changed (e.g. Apple is dropped because of too low market capitalization) you will have to add these changes to the script yourself. The symbols in the script are hard coded.

If you can't or don't want to run *data_download.sh* first, I've put exemplary .csv files into both folders data/nasdaq100 and data/tecdax. I downloaded the stocks quotes on August 7, 2018.

### 2. Open Matlab and import the stock quotes

Put the .csv files into the corresponding folder data/nasdaq100 or data/tecdax and import into Matlab by using the function *data/provide_data.m*. An example is given in the file *example.m*. It is self-explanatory.

To import all data for the nasdaq100 run this code.
```matlab
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
```
After importing all data the structure *stocks_arrays_all_days* is returned.
```matlab
>> stocks_arrays_all_days

stocks_arrays_all_days = 

  struct with fields:

    symbols_vec: {103×1 cell}
          T_vec: [1×5941 double]
          T_idx: [1×5941 double]
        O_array: [103×5941 double]
        H_array: [103×5941 double]
        L_array: [103×5941 double]
        C_array: [103×5941 double]
       AC_array: [103×5941 double]
        V_array: [103×5941 double]
        D_array: [103×5941 double]
        S_array: [103×5941 double]
```
- **symbols_vec**: List of all stock symbols (e.g. Apple = AAPL). A total of 103 symbols. There are actually more than 100 stocks in the nasdaq100 because some companies (e.g. Google) offer two different stocks (with and without voting rights).
- **T_vec**: Represents each point in time as the number of days from January 0, 0000. A total of 5941 days.
- **T_idx**: Represents the index in T_vec for all days available. This is interesting only if you do not import each day (e.g. only Mondays).
- **O_array**: Opening value for each stock (103) on each market day available (5941).
- **O_array**: High
- **L_array**: Low
- **C_array**: Close
- **AC_array**: Adjusted Close
- **V_array**: Volume
- **D_array**: Dividends
- **S_array**: Splits

If a stock was issued later than 5941 market days ago, the values are filled with NaN.
