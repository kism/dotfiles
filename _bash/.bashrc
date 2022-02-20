# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

export PS1="[\[\e[36m\]\u\[\e[m\]@\[\e[36m\]\h\[\e[m\]] \w\n\[\e[35m\]\\$\[\e[m\] "

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
alias youtube-dl='yt-dlp -o "%(upload_date)s %(title)s [%(id)s].%(ext)s"'
