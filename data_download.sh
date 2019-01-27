#!/bin/bash

# error message for wrong inputs
usage()
{
    echo "Usage: $0 [-s path_to_file_with_symbols] [-p <day|1min|5min|15min|30min|60min>]";
    1>&2;
    exit 1;
}

# extract passed arguments
while getopts ":s:p:" opt;
do
	case "${opt}" in

		s)
            filepath_symbols_passed=${OPTARG};
            ;;
    
        p)
            period_passed=${OPTARG};
            ;;

        *)
            usage;;
	esac
done

# check filepath
if [ -z "${filepath_symbols_passed}" ]; then
    echo 'Empty filepath.';
    usage
fi

if [ ! -f "${filepath_symbols_passed}" ]; then
    echo 'File does not exist.';
    usage
fi

# check period
if [ -z "${period_passed}" ]; then
    echo 'Empty period definition.';
    usage
fi
if [ "${period_passed}" != "day" ] && [ "${period_passed}" != "1min" ] && [ "${period_passed}" != "5min" ] && [ "${period_passed}" != "15min" ] && [ "${period_passed}" != "30min" ] && [ "${period_passed}" != "60min" ]; then
    echo 'Unknown period.';
    usage
fi

# extract file name
filename=$(basename -- "${filepath_symbols_passed}");
extension="${filename##*.}";
filename="${filename%.*}";

# alpha vantage variables
if [ "${period_passed}" = "day" ]; then
    aa_function='TIME_SERIES_DAILY_ADJUSTED';
elif [ "${period_passed}" = "1min" ] || [ "${period_passed}" = "5min" ] || [ "${period_passed}" = "15min" ] || [ "${period_passed}" = "30min" ] || [ "${period_passed}" = "60min" ]; then
    aa_function='TIME_SERIES_INTRADAY';
fi
aa_apikey='AF3QF94XJ69S5TPI';
aa_datatype='csv';
aa_outputsize='full';

# if we download a .csv and it is smaller than minimumsize in byte, we assume there was an error
# we wait a few second until we start a retry
minimumsize=1000;
wait_time=3;

# limit tries per symbol
max_tries=30;

# create empty list of ticker symbols
symbols=();

# create empty list of ticker symbols we were unable to download
symbols_download_failed=();

# read in ticker symbols from file and append to array
while IFS=$' \t\n\r' read -r line
do
	# skip lines that start with #
	case "$line" in \#*) continue ;; esac

	# append to symbols
	#symbols+=("$line");

	# append to symbols but replace . with -
	symbols+=("${line//./-}");

done < "$filepath_symbols_passed"

# determine the size of the array
array_size=${#symbols[@]};

# determine date
d=$(date +'%Y_%m_%d_%H_%M_%S');

# create directory were data will be saved
directory="${filename}_${extension}_${period_passed}_${d}";
mkdir $directory;

# now download all symbols one by one
echo " ";
echo " ";
echo "Downloading individual stock data from file ${filepath_symbols_passed}:";
echo " ";
echo " ";

# iterate though all symbols and download data
cnt=0;
for current_symbol in ${symbols[@]}
do
	progress=$((100*$cnt/$array_size));

	# show progress
	echo " ";
	echo "###############################################################################";
	echo "###############################################################################";
	echo "Stocksymbol: $current_symbol --- Index in array (starting with 0): $cnt/$array_size --- Progress:  $progress %";
	echo " ";

	# try downloading file until it's larger than minimumsize or we exceed the maximum number of tries
	tries=0;
	file_downloaded_correctly=false;
	abort_too_many_tries=false;
	while [ ${file_downloaded_correctly} != true ] && [ ${abort_too_many_tries} != true ]
	do
		tries=$(($tries+1));

		# create query string
        if [ "${period_passed}" = "day" ]; then
            aa_query="https://www.alphavantage.co/query?function=${aa_function}&symbol=${current_symbol}&apikey=${aa_apikey}&datatype=${aa_datatype}&outputsize=${aa_outputsize}";
        elif [ "${period_passed}" = "1min" ] || [ "${period_passed}" = "5min" ] || [ "${period_passed}" = "15min" ] || [ "${period_passed}" = "30min" ] || [ "${period_passed}" = "60min" ]; then
            aa_query="https://www.alphavantage.co/query?function=${aa_function}&symbol=${current_symbol}&interval=${period_passed}&outputsize=${aa_outputsize}&datatype=${aa_datatype}&apikey=${aa_apikey}";
        fi

		# path to current file where data is downloaded to
		current_file="$directory/${current_symbol}.csv";

		# query and write to file
		curl $aa_query -o $current_file;

		# determine size of file in byte
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

            # abost if maximum number of tries is exceeded
            if [ $tries -ge $max_tries ]; then
			    echo "Exceedded maximum number of tries, aborting.";
			    echo " ";
                symbols_download_failed+=("${current_symbol}");
			    abort_too_many_tries=true;
            else
			    echo "Going to short sleep before retry.";
			    echo " ";
			    sleep $wait_time;
            fi
		fi
	done

	# increase counter
	cnt=$(($cnt+1));
done

echo " ";
echo "Download failed for:";
echo "${symbols_download_failed[@]}";
echo " ";
echo " ";


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

