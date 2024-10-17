# shellcheck shell=bash
# .bashrc
# https://github.com/kism/dotfiles-simple/blob/main/.bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific aliases and functions
# Prompt
if [ $EUID -eq 0 ]; then
    export PS1="[\[\e[31m\]\u\[\e[m\]@\[\e[31m\]\h\[\e[m\]] \w\n\[\e[33m\]\\$\[\e[m\] "
else
    export PS1="[\[\e[36m\]\u\[\e[m\]@\[\e[36m\]\h\[\e[m\]] \w\n\[\e[35m\]\\$\[\e[m\] "
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm* | rxvt* | alacritty | foot)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*) ;;
esac

if [ -f ~/.bash_aliases ]; then
    # shellcheck source=.bash_aliases
    . ~/.bash_aliases
fi

# Exports
export SYSTEMD_PAGER= # Uncomment this line if you don't like systemctl's auto-paging feature:
export EDITOR=vim
export VISUAL=vim

# Get rust aliases and functions
if [ -f ~/.cargo/env ]; then
    source "$HOME/.cargo/env"
fi
