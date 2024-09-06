# .zshrc
# Source common configuration

export PATH="/opt/homebrew/bin:$PATH"

if [ -f ~/.commonrc ]; then
    source ~/.commonrc
fi

eval "$(brew shellenv)"

# fzf - fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Initialize oh-my-posh with the specified configuration
# oh-my-posh is a prompt theme engine for any shell
eval "$(oh-my-posh init zsh --config ~/.poshthemes/1_shell.omp.json)"

