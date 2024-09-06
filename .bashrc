# ~/.bashrc

# Source user-specific aliases and functions
echo "Sourcing user-specific aliases and functions..."
echo "Checking if ~/dotfiles/bash/utilities/alias_setup.sh exists..."
if [ -f ~/dotfiles/bash/utilities/alias_setup.sh ]; then
    echo "Sourcing alias_setup.sh"
    source ~/dotfiles/bash/utilities/alias_setup.sh
else
    echo "File ~/dotfiles/bash/utilities/alias_setup.sh not found"
fi

# fzf: fuzzy finder
echo "Checking if ~/.fzf.bash exists..."
if [ -f ~/.fzf.bash ]; then
    echo "Sourcing fzf.bash"
    source ~/.fzf.bash
else
    echo "File ~/.fzf.bash not found"
fi

# Enable programmable completion features
echo "Checking for bash completion files..."
if [ -f /etc/bash_completion ]; then
    echo "Sourcing /etc/bash_completion"
    . /etc/bash_completion
elif [ -f /usr/share/bash-completion/bash_completion ]; then
    echo "Sourcing /usr/share/bash-completion/bash_completion"
    . /usr/share/bash-completion/bash_completion
else
    echo "Bash completion files not found"
fi

# Display a custom greeting with system information
echo "Checking if ~/dotfiles/bash/utilities/custom_greeting.sh exists..."
if [ -f ~/dotfiles/bash/utilities/custom_greeting.sh ]; then
    echo "Sourcing custom_greeting.sh"
    source ~/dotfiles/bash/utilities/custom_greeting.sh
else
    echo "File ~/dotfiles/bash/utilities/custom_greeting.sh not found"
fi
