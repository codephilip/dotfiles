#!/bin/bash
# website_status_check.sh
# This script checks the status of a website at regular intervals.
# It logs the status code and sends a notification if the website is down.

URL="http://example.com" # URL to check
LOG_FILE=~/logs/website_status.log # Log file to store website status data

while true; do
    # Get the HTTP status code
    RESPONSE=$(curl -o /dev/null -s -w "%{http_code}\n" $URL)
    
    # Check if the website is down (status code not 200)
    if [ $RESPONSE -ne 200 ]; then
        echo "$(date): $URL is down (status code: $RESPONSE)" >> $LOG_FILE
        notify-send "Website Down" "$URL is not accessible (status code: $RESPONSE)"
    else
        echo "$(date): $URL is up (status code: $RESPONSE)" >> $LOG_FILE
    fi
    
    sleep 300 # Wait for 5 minutes before the next check
done
