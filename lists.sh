#!/bin/bash

usage="Usage: $0 queryName"

source queries.cnf

if [ $# -lt 2 ]
then
    echo $usage
    exit 1
fi

query=${queries[$1]}

if [ -z "$query" ]; then
    echo "Unable to generate the list, because of unknown parameter"
	exit 1
fi

start=$(date +%s.%N)
result=$(mysql --defaults-file=replica.my.cnf -h s2.labsdb -e "$query" itwiki_p)
end=$(date +%s.%N)

runtime=$(python -c "print(${end} - ${start})")
echo "> Runtime: "$runtime

echo "["$(date +%Y%m%d%H%M%S)"] Saving list"
$result > $2
