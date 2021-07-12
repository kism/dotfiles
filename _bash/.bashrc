# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

export PS1="[\[\e[36m\]\u\[\e[m\]@\[\e[36m\]\h\[\e[m\]] \w\n\[\e[35m\]\\$\[\e[m\] "

# Alias
alias ls='ls --color=auto'
alias ll='ls -lh --color=auto'
alias la='ls -lah --color=auto'
alias sl='ls --color=auto'
alias sudp='sudo'
alias please='sudo $(fc -ln -1)'
alias screen="echo no #"
alias cgrep='grep --color=always -e "^" -e'

