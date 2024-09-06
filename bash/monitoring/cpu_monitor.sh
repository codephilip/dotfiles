#!/bin/bash
# cpu_monitor.sh
# This script monitors CPU usage and sends a notification if the usage exceeds a specified threshold.
# It checks the CPU usage at regular intervals.

THRESHOLD=80 # CPU usage threshold percentage

while true; do
    # Get the current CPU usage
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    
    # Check if CPU usage exceeds the threshold
    if (( $(echo "$CPU_USAGE > $THRESHOLD" | bc -l) )); then
        notify-send "CPU Alert" "CPU usage is above $THRESHOLD%. Current usage: $CPU_USAGE%"
    fi
    
    sleep 60 # Wait for 1 minute before the next check
done
