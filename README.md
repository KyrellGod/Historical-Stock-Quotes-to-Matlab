# Historical-Stock-Quotes-to-Matlab
Download data from Alpha Vantage and import it into Matlab.

## How to use it

There are two steps you have to follow.

### 1. Download data from Alpha Vantage into .csv files

Open a terminal and run

```bash
./data_download.sh -i nasdaq100
```
or
```bash
./data_download.sh -i tecdax
```
In both cases it will create a new folder and put all .csv files into it. Also, it will create a compressed version of this folder.

If you want to download another index (e.g. Dow Jones, DAX) you will have to add the stock symbols to the script yourself. Also, if the components of the nasdaq100 are changed (e.g. Apple is dropped due to a low market capitalization) you will have to add these changes to the script yourself. The symbols in the script are hard coded.

### 2. Put the .csv files into the corresponding folder in data/ and import into Matlab.

After downloading the data from Alpha Vantage open Matlab and take a look at the file example.m. It is self-explanatory. To import all data for the nasdaq100 run this code

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

If you can't or don't want to run data_download.sh first, I've put exemplary .csv files into data/. I downloaded them on August 7, 2018.
