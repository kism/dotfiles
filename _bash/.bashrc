# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
# Prompt
#if [ -n "$TERM" -a "$TERM" = 'screen' ]; then
   export PS1="[\[\e[36m\]\u\[\e[m\]@\[\e[36m\]\h\[\e[m\]] \w\n\[\e[35m\]\\$\[\e[m\] "
#else
#   export PS1="[\[\e[36m\]\u\[\e[m\]@\[\e[36m\]\h\[\e[m\]] \w \[\e[41m\] NOT IN TMUX \[\e[m\]  \n\[\e[35m\]\\$\[\e[m\] "
#fi

# Alias
alias ll='ls -l'
alias la='ls -la'
alias sl='ls'
alias sudp='sudo'
alias please='sudo $(fc -ln -1)'
alias screen="echo no #"
alias cgrep='grep --color=always -e "^" -e'

# Startup
#clear
#if test -f /etc/os-release; then
#    . /etc/os-release
#    echo -e "$PRETTY_NAME, \c"
#fi
#uname -s -r

#TMUX_RUNNING="$(pgrep tmux)"

#if [ -n "$TERM" -a "$TERM" = 'screen' ]; then
#    printf ""
#else
#    if [ -z "$TMUX_RUNNING" ]; then
#        echo "No tmux sessions running"
#    else
#        tmux ls
#    fi
#fi
