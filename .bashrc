# shellcheck shell=bash
# .bashrc
# https://github.com/kism/dotfiles-simple/blob/main/.bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
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
export EDITOR=vim
export VISUAL=vim
export SYSTEMD_COLORS=true

# Get rust aliases and functions
if [ -f ~/.cargo/env ]; then
    source "$HOME/.cargo/env"
fi

if [ -d ~/.nvm ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi
