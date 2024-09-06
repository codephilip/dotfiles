#!/bin/bash

echo "Starting macOS setup..."

# Source the common script
source ./install_common.sh

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update Homebrew
echo "Updating Homebrew..."
brew update

# Install necessary dependencies
echo "Installing necessary dependencies..."
brew install git zsh neovim tmux curl unzip bat fzf

# Setup Neovim configuration
echo "Setting up Neovim configuration..."
mkdir -p ~/.config
cp -r "$SCRIPT_DIR/nvim" ~/.config/nvim

# Setup Tmux configuration
echo "Setting up Tmux configuration..."
cp ~/.tmux.conf ~/.tmux.conf.bak 2>/dev/null
mkdir -p $SCRIPT_DIR/.tmux
git clone https://github.com/tmux-plugins/tpm ~/dotfiles/.tmux/plugins/tpm
ln -sf ~/dotfiles/.tmux/.tmux.conf ~/.tmux.conf
tmux source-file ~/.tmux.conf

# Setup Zsh configuration
echo "Setting up Zsh configuration..."
cp ~/.zshrc ~/.zshrc.bak 2>/dev/null
ln -sf "$SCRIPT_DIR/.zshrc" ~/
source ~/.zshrc

# Install and configure oh-my-posh
echo "Installing and configuring oh-my-posh..."
brew install jandedobbeleer/oh-my-posh/oh-my-posh
mkdir -p ~/.poshthemes
curl -o ~/.poshthemes/themes.zip -L https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip
unzip ~/.poshthemes/themes.zip -d ~/.poshthemes
chmod u+rw ~/.poshthemes/*.json
#echo 'eval "$(oh-my-posh init zsh --config ~/.poshthemes/montys.omp.json)"' >> ~/.zshrc


echo "macOS setup complete!"
