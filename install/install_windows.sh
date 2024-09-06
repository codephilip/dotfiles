#!/bin/bash

echo "Starting Windows setup..."

# Source the common script
source ./install_common.sh

SCRIPT_DIR=$(dirname "$(realpath "$0")")
CONFIG_DIR="$HOME/.config"

echo "Script directory: $SCRIPT_DIR"

# Ensure ~/.config exists
echo "Creating ~/.config directory if it doesn't exist..."
mkdir -p "$CONFIG_DIR"

# Copy Neovim configuration
echo "Create Symlink Neovim configuration..."
ln -sfn "$SCRIPT_DIR/nvim" "$HOME/.config/nvim"
echo "Neovim configuration copied!"


# Check if Scoop is installed
echo "Checking if Scoop is installed..."

# Check if Scoop is installed, if not, install it
if ! command -v scoop &> /dev/null; then
    echo "Scoop is not installed. Installing Scoop..."
    if powershell -Command "iwr -useb get.scoop.sh | iex"; then
        echo "Scoop installed successfully."
    else
        echo "Failed to install Scoop. Exiting."
        exit 1
    fi
fi


# Install necessary dependencies using Scoop
echo "Installing necessary dependencies using Scoop..."
echo "Installing neovim, curl, unzip, bat..."
scoop install neovim curl bat unzip


# Install and configure oh-my-posh
echo "Installing oh-my-posh themes..."
mkdir -p ~/.poshthemes
curl -o ~/.poshthemes/themes.zip -L https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip
unzip ~/.poshthemes/themes.zip -d ~/.poshthemes
chmod u+rw ~/.poshthemes/*.json
echo "Follow the manual setup in Readme to install oh-my-posh and customize themes"

# Symlink common configurations
echo "Creating copies for common configurations..."
echo ".commonrc, .profile, .bashrc, .gitconfig -> ~/"
cp "$SCRIPT_DIR/.commonrc" ~/
cp "$SCRIPT_DIR/.bash_profile" ~/
cp "$SCRIPT_DIR/.bashrc" ~/
cp "$SCRIPT_DIR/.gitconfig" ~/

echo "Manually Configure TMUX, NVIM, and oh-my-posh"

# Install WSL
echo "Checking if WSL is installed..."
if ! powershell -Command "Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux" | grep -q "Enabled"; then
    echo "WSL is not installed. Installing WSL..."
    powershell -Command "wsl --install"
    echo "WSL installed successfully."
else
    echo "WSL is already installed."
fi

echo "Windows setup complete!"

read -p "Press Enter to close the terminal..."