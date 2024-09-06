#!/bin/bash
# update_system.sh
# This script updates system packages and performs a cleanup to remove unnecessary files.
# It is useful for keeping the system up-to-date and freeing up disk space.

echo "Updating system packages..." # Notify the user that the update is starting
sudo apt update && sudo apt upgrade -y # Update and upgrade system packages
sudo apt autoremove -y && sudo apt clean # Remove unnecessary packages and clean up
echo "System update and cleanup completed." # Notify the user that the update is complete
