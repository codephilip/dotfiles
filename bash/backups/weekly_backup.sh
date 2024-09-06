#!/bin/bash
# weekly_backup.sh
# This script performs weekly backups of important directories.
# It creates a compressed archive of each source directory to save space
# and to keep a snapshot of the directory as it was at the time of the backup.

BACKUP_DIR="/backup/weekly" # Backup directory
SOURCE_DIRS=("/home/user/documents" "/home/user/photos") # Directories to backup
DATE=$(date +%Y-%m-%d-%H-%M-%S) # Current date and time
mkdir -p $BACKUP_DIR # Ensure backup directory exists

# Loop through each source directory and create a compressed archive
for DIR in "${SOURCE_DIRS[@]}"; do
    tar -czf "$BACKUP_DIR/$(basename $DIR)-$DATE.tar.gz" "$DIR"
done

# Log the completion of the backup
echo "Weekly backup completed on $DATE" >> $BACKUP_DIR/backup.log
