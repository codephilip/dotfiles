#!/bin/bash

# This script performs a common setup by downloading and installing the Nerd Font.
# It determines the script's directory, creates a Downloads directory if it doesn't exist,
# downloads the Nerd Font zip file, extracts it, and installs the font based on the operating system.
# Finally, it cleans up the downloaded files.

# Get the directory of the script
SCRIPT_DIR=$(dirname "$(realpath "$0")")

FONT_DIR="$SCRIPT_DIR/.fonts"
echo "Starting common setup..."

echo "Install Fonts"
find "$FONT_DIR" -type f -name "*.ttf" | while read -r FONT_PATH; do
    echo "Installing font: $FONT_PATH"
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux (Ubuntu)
        FONT_DEST="$HOME/.local/share/fonts"
        mkdir -p "$FONT_DEST"
        cp "$FONT_PATH" "$FONT_DEST"
        fc-cache -f -v
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        FONT_DEST="$HOME/Library/Fonts"
        cp "$FONT_PATH" "$FONT_DEST"
    elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        # Windows
        WIN_FONT_PATH=$(cygpath -w "$FONT_PATH")
        powershell.exe -Command "
            \$fontPath = '$WIN_FONT_PATH'
            \$fontsFolder = [System.Environment]::GetFolderPath('Fonts')
            Copy-Item -Path \$fontPath -Destination \$fontsFolder
            \$fontRegKey = 'HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Fonts'
            \$fontName = [System.IO.Path]::GetFileNameWithoutExtension(\$fontPath) + ' (TrueType)'
            Set-ItemProperty -Path \$fontRegKey -Name \$fontName -Value \$fontPath
        "
    else
        echo "Unsupported OS: $OSTYPE"
    fi
done
echo "Fonts installed!"

# Get the directory of the script
SCRIPT_DIR=$(dirname "$(realpath "$0")")

FZF_DIR="$HOME/.fzf"
CONFIG_DIR="$HOME/.config"
DOTFILES_DIR="/c/Users/phili/dotfiles"
done
echo "Fonts installed!"

# Setup fzf
echo "Cloning and installing fzf..."
git clone https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

echo "Common setup complete!"
