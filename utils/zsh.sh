#!/usr/bin/env bash

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Set up the config file
cat > ~/.zshrc <<EOF
export ZSH="/Users/bnjns/.oh-my-zsh"
ZSH_THEME="agnoster"

plugins=(git)

source $ZSH/oh-my-zsh.sh
prompt_context(){}
EOF

# Reload
. ~/.zshrc