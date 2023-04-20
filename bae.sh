#!/bin/bash

# Define the URL or IP address to ping
echo "Enter the URL or IP address to ping:"
read url

# Define the log file and write the start of the test
log_file="ping_log.txt"
echo "Starting internet connectivity test at $(date)" >> $log_file

# Loop every 55 seconds to test internet connectivity
while true
do
    # Ping the URL or IP address
    ping -c 1 $url > /dev/null

    # Check the exit code of the ping command
    if [[ $? != 0 ]]
    then
        # If the ping fails, log the result with the time and date
        echo "Internet connectivity test failed at $(date)" >> $log_file
    fi

    # Wait 55 seconds before running the next iteration
    sleep 55
done &

