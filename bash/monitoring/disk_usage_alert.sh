#!/bin/bash
# disk_usage_alert.sh
# This script monitors disk usage and sends a notification if the usage exceeds a specified threshold.
# It checks the disk usage at regular intervals.

THRESHOLD=90 # Disk usage threshold percentage

while true; do
    # Get the current disk usage
    USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
    
    # Check if disk usage exceeds the threshold
    if [ $USAGE -gt $THRESHOLD ]; then
        notify-send "Disk Usage Alert" "Disk usage is above $THRESHOLD%. Current usage: $USAGE%"
    fi
    
    sleep 3600 # Wait for 1 hour before the next check
done
