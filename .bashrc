# shellcheck shell=bash
# .bashrc
# https://github.com/kism/dotfiles/blob/main/.bashrc

# Source global definitions (RHEL/Rocky; Debian/Ubuntu bash reads /etc/bash.bashrc by itself)
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# set PATH so it includes user's private bin dirs, once each, ~/.local/bin first
for d in "$HOME/bin" "$HOME/.local/bin"; do
    case ":$PATH:" in
    *":$d:"*) ;;
    *) [ -d "$d" ] && PATH="$d:$PATH" ;;
    esac
done
unset d
export PATH

# User snippets, as RHEL/Rocky's default .bashrc does
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        # shellcheck disable=SC1090 # user snippets, unknown at lint time
        [ -f "$rc" ] && . "$rc"
    done
    unset rc
fi

# If not running interactively (scp, rsync, ssh host cmd), don't do anything else
case $- in
*i*) ;;
*) return ;;
esac

# History, Ubuntu's skel sets these but this file replaces it
HISTCONTROL=ignoreboth # skip duplicates and commands starting with a space
HISTSIZE=12000
HISTFILESIZE=10000
shopt -s histappend # append, so closing one terminal doesn't clobber another's history

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

# Tab completion, Ubuntu's skel loads it (RHEL/Rocky already did via /etc/profile.d)
if [ -z "${BASH_COMPLETION_VERSINFO:-}" ] && ! shopt -oq posix; then
    for f in /usr/share/bash-completion/bash_completion /etc/bash_completion /opt/homebrew/etc/profile.d/bash_completion.sh; do
        if [ -f "$f" ]; then
            # shellcheck disable=SC1090 # path differs per distro
            . "$f"
            break
        fi
    done
    unset f
fi

# less on .gz/.tar etc, Ubuntu's skel does this (RHEL/Rocky sets LESSOPEN in /etc/profile.d)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Exports
export EDITOR=vim
export VISUAL=vim
export SYSTEMD_COLORS=true
export SYSTEMD_PAGER=

# Get rust aliases and functions
if [ -f ~/.cargo/env ]; then
    source "$HOME/.cargo/env"
fi

if [ -s "$HOME/.nvm/nvm.sh" ]; then
    export NVM_DIR="$HOME/.nvm"
    \. "$NVM_DIR/nvm.sh" --no-use                                      # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
    # --no-use skips nvm resolving the default alias (~200ms), so put the newest matching install on PATH ourselves
    # ponytail: assumes alias/default is a version (26, v26.8.2), not lts/* or node; those get no node until `nvm use`
    if [ -s "$NVM_DIR/alias/default" ]; then
        nvm_default=$(<"$NVM_DIR/alias/default")
        nvm_default=${nvm_default#v}
        nvm_bin=$(compgen -G "$NVM_DIR/versions/node/v$nvm_default*" | grep -E "/v${nvm_default//./\\.}(\.|$)" | sort -V | tail -1)
        case ":$PATH:" in
        *":$nvm_bin/bin:"*) ;;
        *) [ -n "$nvm_bin" ] && PATH="$nvm_bin/bin:$PATH" ;;
        esac
        unset nvm_default nvm_bin
    fi
fi
