#!/bin/bash
# daily_backup.sh
# This script performs daily backups of important directories.
# It uses rsync to copy files from source directories to a backup directory,
# ensuring that the backup is always up-to-date and only includes changes since the last backup.

BACKUP_DIR="/backup/daily" # Backup directory
SOURCE_DIRS=("/home/user/documents" "/home/user/photos") # Directories to backup
DATE=$(date +%Y-%m-%d) # Current date
mkdir -p $BACKUP_DIR # Ensure backup directory exists

# Loop through each source directory and perform the backup using rsync
for DIR in "${SOURCE_DIRS[@]}"; do
    rsync -av --delete "$DIR" "$BACKUP_DIR/$(basename $DIR)-$DATE"
done

# Log the completion of the backup
echo "Daily backup completed on $DATE" >> $BACKUP_DIR/backup.log
