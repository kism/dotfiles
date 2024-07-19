# .bashrc

PATH=$PATH:$HOME/bin:$HOME/.local/bin
export PATH

# Fix non interactive everything breaking
[[ $- != *i* ]] && return

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
# Prompt

# Preflight checks
if [ $EUID -eq 0 ] ; then
        export PS1="[\[\e[31m\]\u\[\e[m\]@\[\e[31m\]\h\[\e[m\]] \w\n\[\e[33m\]\\$\[\e[m\] "
else
        export PS1="[\[\e[36m\]\u\[\e[m\]@\[\e[36m\]\h\[\e[m\]] \w\n\[\e[35m\]\\$\[\e[m\] "
fi

# Alias
alias ls='ls --color=auto'
alias ll='ls -lh --color=auto'
alias la='ls -halal --color=auto'
alias sl='ls --color=auto'

alias please='sudo $(fc -ln -1)'
alias sudp='sudo'
alias tmux='tmux -u'
alias sl='ls'
alias nano='vim'
alias bim='echo -e "\033[0;31m\033[0;41mB\033[0mim"'
alias screen='echo no #'
alias cgrep='grep --color=always -e "^" -e'
alias whom=who

export EDITOR=vim
export VISUAL=vim
