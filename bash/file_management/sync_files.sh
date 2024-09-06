#!/bin/bash
# sync_files.sh
# This script synchronizes files between a source directory and a destination directory
# using rsync. It ensures that the destination directory is a mirror of the source directory.

SOURCE_DIR=~/Documents # Source directory
DEST_DIR=~/Backup/Documents # Destination directory

# Perform the synchronization using rsync
rsync -av --delete $SOURCE_DIR $DEST_DIR
