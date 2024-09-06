#!/bin/bash

echo "Starting Linux setup..."

# Source the common script
source ./install_common.sh

# Update package lists
echo "Updating package lists..."
sudo apt update

# Install necessary dependencies
echo "Installing necessary dependencies..."
sudo apt install -y git zsh neovim tmux curl unzip bat fzf

# Setup Neovim configuration
echo "Setting up Neovim configuration..."
mkdir -p ~/.config
cp -r "$SCRIPT_DIR/nvim" ~/.config/nvim

# Setup Tmux configuration
echo "Setting up Tmux configuration..."
cp ~/.tmux.conf ~/.tmux.conf.bak 2>/dev/null
mkdir -p $SCRIPT_DIR/.tmux

tmux source-file ~/.tmux.conf

# Setup Zsh configuration
echo "Setting up Zsh configuration..."
cp ~/.zshrc ~/.zshrc.bak 2>/dev/null
ln -sf "$SCRIPT_DIR/.zshrc" ~/
source ~/.zshrc


# Install and configure oh-my-posh
echo "Installing and configuring oh-my-posh..."
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh
mkdir -p ~/.poshthemes
curl -o ~/.poshthemes/themes.zip -L https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip
unzip ~/.poshthemes/themes.zip -d ~/.poshthemes
chmod u+rw ~/.poshthemes/*.json
#echo 'eval "$(oh-my-posh init zsh --config ~/.poshthemes/montys.omp.json)"' >> ~/.zshrc


echo "Linux setup complete!"
