#!/bin/bash
# alias_setup.sh
# This script sets up custom aliases for common commands to simplify and speed up command-line operations.

# Aliases for navigation
#alias ll='ls -lah' # List all files with detailed information
alias ..='cd ..' # Go up one directory
alias ...='cd ../..' # Go up two directories
alias ....='cd ../../..' # Go up three directories

# Git aliases
alias gs='git status' # Show the status of the Git repository
alias ga='git add .' # Add all changes to the staging area
alias gc='git commit -m' # Commit changes with a message
alias gp='git push' # Push changes to the remote repository
alias gl='git log' # Show the Git commit history
alias gco='git checkout' # Checkout a branch or commit
alias gb='git branch' # List all branches
alias gd='git diff' # Show the changes between commits, branches, or files
alias gpl='git pull' # Pull changes from the remote repository
alias gcp='git cherry-pick' # Apply the changes introduced by some existing commits
alias gcb='git checkout -b' # Create and checkout a new branch
alias gcl='git clone' # Clone a repository into a new directory
alias gr='git remote' # Manage set of tracked repositories
alias grv='git remote -v' # Show URLs that Git has stored for the shortname to be used when reading and writing
alias gsta='git stash' # Stash changes in a dirty working directory away
alias gstp='git stash pop' # Apply the topmost stash
alias gsp='git show' # Show various types of objects
alias gbd='git branch -d' # Delete a branch
#TODO: Add worktree

# VS Code alias
alias code='code .' # Open the current directory in Visual Studio Code

# Docker aliases
alias dcu='docker-compose up' # Start Docker containers using Docker Compose
alias dcd='docker-compose down' # Stop Docker containers using Docker Compose
alias dcb='docker-compose build' # Build Docker images using Docker Compose
alias dcl='docker-compose logs' # Show logs for Docker containers
alias dcr='docker-compose restart' # Restart Docker containers using Docker Compose

# System update and cleanup aliases
alias update='sudo apt update && sudo apt upgrade -y' # Update and upgrade system packages
alias cleanup='sudo apt autoremove -y && sudo apt clean' # Remove unnecessary packages and clean up

# Networking aliases
alias myip='curl ipinfo.io/ip' # Show the external IP address
alias pingg='ping google.com' # Ping Google's server to check network connectivity

# Custom commands
alias find_large='find . -type f -size +100M' # Find files larger than 100MB in the current directory
alias free_mem='free -h' # Show free memory in human-readable format
alias top_cpu='ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head' # Show top processes by CPU usage
alias extract='tar -xf' # Extract tar files quickly

# Custom alias for quickly navigating to common directories
alias docs='cd ~/Documents'
alias dls='cd ~/Downloads'
alias pjt='cd ~/projects'

# Custom alias for clearing the terminal
alias cls='clear'

# Aliases for environment setup scripts
alias create-react='~/.config/bash/environment_setup/create_react_project.sh'
alias setup-dev='~/.config/bash/environment_setup/dev_env_setup.sh'
alias setup-prod='~/.config/bash/environment_setup/prod_env_setup.sh'
alias setup-test='~/.config/bash/environment_setup/test_env_setup.sh'

# Aliases for fzf commands
alias fcd='cd $(find . -type d | fzf)' # Fuzzy search and change directory
alias fvi='vi $(find . -type f | fzf)' # Fuzzy search and open file with vi
alias fvsc='code $(find . -type f | fzf)' # Fuzzy search and open file with VS Code
alias fhist='history | fzf' # Fuzzy search command history
alias fkill='kill -9 $(ps -ef | fzf | awk "{print $2}")' # Fuzzy search and kill process

# Source this file in your ~/.bashrc or ~/.bash_profile
# source ~/.config/bash/utilities/alias_setup.sh
