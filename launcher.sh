#!/bin/bash

usage="Usage: $0 setFile"

if [ $# -lt 1 ]
then
    echo $usage
    exit 1
fi

date=$(date +"%Y%m%d")

echo "-----------------------"
echo "["$(date +%Y%m%d%H%M%S)"] Starting launcher!"

#####

count=1
while read line           
do
if [[ ! $line == \#* ]]; then
    case $count in
        1)
            name=$line
		    ;;
	    2)
            list_path=$line${date}.txt
		    ;;
	    3)
            py_path=$line
		    ;;
	    4)
            log_path=$line
		    ;;
	    5)
            echo "["$(date +%Y%m%d%H%M%S)"] Generating list for ${name}..."
            ./lists.sh "$name" "$list_path"

            echo "["$(date +%Y%m%d%H%M%S)"] Launching python script for ${name}..."
            python $py_path $name >> $log_path 2>&1 &
		
		    count=0
		    ;;
    esac
    let count++
fi
done < $1

#####

echo "["$(date +%Y%m%d%H%M%S)"] Ending launcher!"