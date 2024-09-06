# ~/.bash_profile or ~/.profile

# Source .bashrc from ~/.config if it exists
if [ -f ~/dotfiles/bash/.bashrc ]; then
    source ~/dofiles/bash/.bashrc
fi

# Source .bashrc if it exists
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

export PATH="$HOME/dotfiles/scripts:$PATH"

