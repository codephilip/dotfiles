#!/bin/bash
# custom_greeting.sh
# This script displays a custom greeting message when a new terminal session is started.
# It includes the current date and disk usage information. It attempts to display the system uptime if available.

# Display a greeting message with the current date
echo "Welcome, $(whoami)! Today is $(date +'%A, %B %d, %Y')."

# Check if uptime command is available and display system load
if command -v uptime > /dev/null 2>&1; then
    echo "System Load: $(uptime -p)"
else
    echo "System Load: uptime command not found."
fi

# Display the disk usage for the root filesystem
if command -v df > /dev/null 2>&1 && command -v grep > /dev/null 2>&1; then
    echo "Disk Usage: $(df -h / | grep / | awk '{ print $5 }')"
else
    echo "Disk Usage: df or grep command not found."
fi