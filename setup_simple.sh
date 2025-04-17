#!/usr/bin/env bash

# Download all the dotfiles
# Exit the script if there is an error
set -e

# Bash
echo Setting up bash...
curl --silent -L https://raw.githubusercontent.com/kism/dotfiles/main/.bashrc -o ~/.bashrc
curl --silent -L https://raw.githubusercontent.com/kism/dotfiles/main/.bash_profile -o ~/.bash_profile
curl --silent -L https://raw.githubusercontent.com/kism/dotfiles/main/.bash_aliases -o ~/.bash_aliases
curl --silent -L https://raw.githubusercontent.com/kism/dotfiles/main/.inputrc -o ~/.inputrc

# Tmux
echo Setting up tmux...
curl --silent -L https://raw.githubusercontent.com/kism/dotfiles/main/.tmux.conf -o ~/.tmux.conf
if [ $EUID -eq 0 ]; then # If this is setting up the root user account, make the tmux bar red
    sed -i 's/green/red/g' ~/.tmux.conf
    sed -i 's/colour10/colour9/g' ~/.tmux.conf
fi

# Vim
echo Setting up vim...
curl --silent -L https://raw.githubusercontent.com/kism/dotfiles/main/.vimrc -o ~/.vimrc

# NeoVim
echo Setting up neovim...
mkdir -p ~/.config/nvim/
curl --silent -L https://raw.githubusercontent.com/kism/dotfiles/main/.config/nvim/init.lua -o ~/.config/nvim/init.lua

# Htop
echo Setting up htop...
mkdir -p ~/.config/htop/
curl --silent https://raw.githubusercontent.com/kism/dotfiles/main/.config/htop/htoprc -o ~/.config/htop/htoprc

# Btop
echo Setting up btop...
mkdir -p ~/.config/btop/
curl --silent https://raw.githubusercontent.com/kism/dotfiles/main/.config/btop/btop.conf -o ~/.config/btop/btop.conf


if [ "$1" == "--gui" ]; then
    echo Setting up ghostty
    mkdir -p ~/.config/ghostty/
    curl --silent https://raw.githubusercontent.com/kism/dotfiles/main/.config/ghostty/config -o ~/.config/ghostty/config
fi

# Zsh
echo Setting up zsh...
curl --silent -L https://raw.githubusercontent.com/kism/dotfiles/main/.zshrc -o ~/.zshrc

# Terminfo
echo Setting up terminfo...
mkdir -p ~/.terminfo/g/
mkdir -p ~/.terminfo/x/
curl --silent -L https://github.com/kism/dotfiles/raw/refs/heads/main/.terminfo/g/ghostty -o ~/.terminfo/g/ghostty
curl --silent -L https://github.com/kism/dotfiles/raw/refs/heads/main/.terminfo/x/xterm-ghostty -o ~/.terminfo/x/xterm-ghostty
