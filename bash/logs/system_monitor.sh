#!/bin/bash
# system_monitor.sh
# This script monitors system performance metrics and logs them.
# It records CPU usage, memory usage, and disk usage at regular intervals.

LOG_FILE=~/logs/system_monitor.log # Log file to store system performance data

while true; do
    # Log CPU usage
    echo "CPU: $(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')" >> $LOG_FILE
    
    # Log memory usage
    echo "Memory: $(free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }')" >> $LOG_FILE
    
    # Log disk usage
    echo "Disk: $(df -h | awk '$NF=="/"{printf "Disk Usage: %d/%dGB (%s)\n", $3,$2,$5}')" >> $LOG_FILE
    
    sleep 60 # Wait for 1 minute before the next log
done
