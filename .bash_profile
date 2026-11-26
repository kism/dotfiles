# shellcheck shell=bash
# .bash_profile
# https://github.com/kism/dotfiles/blob/main/.bash_profile

# Everything lives in .bashrc, which sets PATH then returns early for non-interactive shells
if [ -f ~/.bashrc ]; then
    # shellcheck source=.bashrc
    source ~/.bashrc
fi
