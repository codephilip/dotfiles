#!/bin/bash

echo "Starting main installation script..."

# Get the directory of the script
SCRIPT_DIR=$(dirname "$(realpath "$0")")
echo "Script directory: $SCRIPT_DIR"

# Determine the OS and call the appropriate script
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Detected macOS"
    source "$SCRIPT_DIR/install_mac.sh"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Detected Linux"
    source "$SCRIPT_DIR/install_linux.sh"
elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    echo "Detected Windows"
    bash "$SCRIPT_DIR/install_windows.sh"
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

echo "Main installation script complete!"
