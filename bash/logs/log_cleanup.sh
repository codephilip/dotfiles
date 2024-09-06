#!/bin/bash
# log_cleanup.sh
# This script cleans up old log files to free up disk space.
# It deletes log files older than a specified number of days in the log directory.

LOG_DIR="/var/log" # Directory containing log files
DAYS_TO_KEEP=30 # Number of days to keep log files

# Find and delete log files older than the specified number of days
find $LOG_DIR -type f -name "*.log" -mtime +$DAYS_TO_KEEP -exec rm -f {} \;

# Log the cleanup operation
echo "Log cleanup completed. Logs older than $DAYS_TO_KEEP days have been deleted."
