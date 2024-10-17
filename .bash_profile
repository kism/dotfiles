# shellcheck shell=bash
# .bash_profile
# https://github.com/kism/dotfiles-simple/blob/main/.bash_profile

PATH=$PATH:$HOME/bin:$HOME/.local/bin
export PATH

# Fix non interactive everything breaking
[[ $- != *i* ]] && return

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
  # shellcheck source=.bashrc
  source ~/.bashrc
fi
