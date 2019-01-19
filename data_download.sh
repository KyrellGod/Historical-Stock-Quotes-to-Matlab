#!/bin/bash

# extract index from passed arguments
while getopts "i:" opt;
do
	case "${opt}"
		in
		i) idx_passed=${OPTARG};;
	esac
done

# alpha vantage variables
aa_function='TIME_SERIES_DAILY_ADJUSTED';
aa_apikey='AF3QF94XJ69S5TPI';
aa_datatype='csv';
aa_outputsize='full';

# we can also download the index itself, it will be appended at the end of the symbols list
download_idx_data=true;

# if we download a .csv and it is smaller than minimumsize in byte, we assume there was an error
# we wait a few second until we start a retry
minimumsize=1000;
wait_time=3;

# compare passed argument with any known index and make sure it is valid
if [ "${idx_passed}" = "nasdaq100" ]; then

	# source: https://www.nasdaq.com/quotes/nasdaq-100-stocks.aspx

	idx='nasdaq100';
	idx_symbol='NDX';
	ticker_symbol_file='ticker_symbol/nasdaq100.csv';
	

elif [ "${idx_passed}" = "sp500" ]; then

	# source: https://en.wikipedia.org/wiki/List_of_S%26P_500_companies
	# nice tool for converting html table to csv file: http://www.convertcsv.com/html-table-to-csv.htm

	idx='sp500';
	idx_symbol='^SPX';
	ticker_symbol_file='ticker_symbol/sp500.csv';

else

	echo " ";
	echo "Unknown index type: ${idx_passed}."
	echo " ";
	exit 1;

fi

# create empty list of ticker symbols
symbols=();

# read in ticker symbols from file and append to array
while IFS=$' \t\n\r' read -r line
do
	# skip lines that start with #
	case "$line" in \#*) continue ;; esac

	# append to symbols
	#symbols+=("$line");

	# append to symbols but replace . with -
	symbols+=("${line//./-}");

done < "$ticker_symbol_file"

# download index data if we are interested in it
if [ $download_idx_data = true ] ; then
	symbols+=("$idx_symbol");
fi

# determine the size of the array
array_size=${#symbols[@]};

# determine date
d=$(date +'%Y_%m_%d_%H_%M_%S');

# create directory were data will be saved
directory="${idx}_${d}";
mkdir $directory;

# now download all symbols one by one
echo " ";
echo " ";
echo "Downloading individual stock data for index ${idx} with symbol ${idx_symbol}:";
echo " ";
echo " ";

# iterate though all symbols and download data
cnt=0;
for current_symbol in ${symbols[@]}
do
	progress=$((100*$cnt/$array_size));

	# show progess
	echo " ";
	echo "###############################################################################";
	echo "###############################################################################";
	echo "Stocksymbol: $current_symbol --- Index in array (starting with 0): $cnt/$array_size --- Progress:  $progress %";
	echo " ";

	# try downloading file until it's larger than minimumsize, otherwise there was an error
	tries=0;
	file_downloaded_correctly=false;
	while [ ${file_downloaded_correctly} != true ]
	do
		tries=$(($tries+1));

		# create query string
		aa_query="https://www.alphavantage.co/query?function=${aa_function}&symbol=${current_symbol}&apikey=${aa_apikey}&datatype=${aa_datatype}&outputsize=${aa_outputsize}";

		# path to current file where data is downloaded to
		current_file="$directory/${current_symbol}.csv";

		# query and write to file
		curl $aa_query -o $current_file;

		# detemine size of file in byte
		actualsize=$(wc -c <$current_file);

		# check if file reaches minimum size
		if [ $actualsize -ge $minimumsize ]; then
			echo " ";
			echo "File downloaded successfully for symbol $current_symbol (idx in list=$cnt).";
			echo "Filesize: $actualsize";
			echo "Try: $tries";
			file_downloaded_correctly=true;
		else
			echo " ";
			echo "File too small for symbol $current_symbol (idx in list=$cnt).";
			echo "Filesize: $actualsize";
			echo "Try: $tries";
			echo "Removing file.";
			#sleep 3; # debugging: check if file is actually deleted
			rm $current_file;
			echo "Going to short sleep before retry.";
			echo " ";
			sleep $wait_time;
		fi
	done

	# increase counter
	cnt=$(($cnt+1));
done

echo " ";
echo "done downloading";
echo " ";
echo " ";

# compress folder with data
tar -zcf ${directory}.tar.gz ${directory}

echo " ";
echo "done compressing";
echo " ";
echo " ";

