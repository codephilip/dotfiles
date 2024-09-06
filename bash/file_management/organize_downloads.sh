#!/bin/bash
# organize_downloads.sh
# This script organizes files in the Downloads directory by moving them to specific subdirectories
# based on their file types.

DOWNLOADS=~/Downloads # Directory to organize
mkdir -p $DOWNLOADS/Documents $DOWNLOADS/Images $DOWNLOADS/Archives # Create subdirectories if they don't exist

# Move PDF files to Documents
mv $DOWNLOADS/*.pdf $DOWNLOADS/Documents/

# Move image files to Images
mv $DOWNLOADS/*.jpg $DOWNLOADS/*.png $DOWNLOADS/Images/

# Move archive files to Archives
mv $DOWNLOADS/*.zip $DOWNLOADS/*.tar.gz $DOWNLOADS/Archives/
