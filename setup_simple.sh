#!/usr/bin/env bash

# Download all the dotfiles
# Exit the script if there is an error
set -e

# Bash
echo Setting up bash...
curl --silent -L https://raw.githubusercontent.com/kism/dotfiles/main/.bash_profile >~/.bash_profile
curl --silent -L https://raw.githubusercontent.com/kism/dotfiles/main/.bashrc >~/.bashrc
curl --silent -L https://raw.githubusercontent.com/kism/dotfiles/main/.inputrc >~/.inputrc

# Tmux
echo Setting up tmux...
curl --silent -L https://raw.githubusercontent.com/kism/dotfiles/main/.tmux.conf >~/.tmux.conf
if [ $EUID -eq 0 ]; then # If this is setting up the root user account, make the tmux bar red
    sed -i 's/green/red/g' ~/.tmux.conf
    sed -i 's/colour10/colour9/g' ~/.tmux.conf
fi

# Vim
echo Setting up vim...
curl --silent -L https://raw.githubusercontent.com/kism/dotfiles/main/.vimrc >~/.vimrc

# NeoVim
echo Setting up neovim...
mkdir -p ~/.config/nvim/
curl --silent -L https://raw.githubusercontent.com/kism/dotfiles/main/.config/nvim/init.lua >~/.config/nvim/init.lua

# Htop
echo Setting up htop...
mkdir -p ~/.config/htop/
curl --silent https://raw.githubusercontent.com/kism/dotfiles/main/.config/htop/htoprc >~/.config/htop/htoprc
