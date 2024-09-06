#!/bin/bash
# uptime_logger.sh
# This script logs system uptime once a day.
# It appends the current uptime to a log file with a timestamp.

LOG_FILE=~/logs/uptime.log # Log file to store uptime data

while true; do
    # Log the current date and uptime
    echo "$(date): $(uptime -p)" >> $LOG_FILE
    sleep 86400 # Wait for 24 hours (86400 seconds) before the next log
done
