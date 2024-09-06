#!/bin/bash
# rename_files.sh
# This script renames files in a target directory by adding a timestamp to their filenames.

TARGET_DIR=~/Downloads # Directory containing files to rename

# Loop through each text file and rename it with a timestamp
for file in $TARGET_DIR/*.txt; do
    mv "$file" "$TARGET_DIR/$(date +%Y%m%d)_$(basename "$file")"
done
