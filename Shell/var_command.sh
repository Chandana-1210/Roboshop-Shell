#!/bin/bash
# date_name=$(date +%s)
# echo "script execution timestamp:$date_name"
start_time=$(date +%s)
sleep 15
end_time=$(date +%s)
total_time=$(($end_time-$start_time))
echo "script execution completed in $total_time seconds"
