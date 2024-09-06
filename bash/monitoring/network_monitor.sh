#!/bin/bash
# network_monitor.sh
# This script monitors network usage by tracking the amount of data received and transmitted.
# It logs the network usage at regular intervals.

LOG_FILE=~/logs/network_monitor.log # Log file to store network usage data

while true; do
    # Get the initial data received and transmitted
    RX=$(cat /sys/class/net/eth0/statistics/rx_bytes)
    TX=$(cat /sys/class/net/eth0/statistics/tx_bytes)
    
    sleep 1 # Wait for 1 second
    
    # Get the new data received and transmitted
    RX_NEW=$(cat /sys/class/net/eth0/statistics/rx_bytes)
    TX_NEW=$(cat /sys/class/net/eth0/statistics/tx_bytes)
    
    # Calculate the data rates
    RX_RATE=$(( ($RX_NEW - $RX) / 1024 ))
    TX_RATE=$(( ($TX_NEW - $TX) / 1024 ))
    
    # Log the data rates
    echo "$(date): RX: ${RX_RATE}KB/s, TX: ${TX_RATE}KB/s" >> $LOG_FILE
done
