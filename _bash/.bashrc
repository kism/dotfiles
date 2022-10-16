# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

function get_mercury_retrograde() {
    RESULT=""
    RETROGRADETEMPFILE="/tmp/mercuryretrograde"

    if ! [ -f "$RETROGRADETEMPFILE" ]; then
        touch "$RETROGRADETEMPFILE"
    fi

    if type nohup > /dev/null && type curl > /dev/null; then

        if [[ $(find "$RETROGRADETEMPFILE" -mtime -0.25 -print) ]]; then
            nohup curl -s https://mercuryretrogradeapi.com > $RETROGRADETEMPFILE 2>/dev/null
        fi

        if cat /tmp/mercuryretrograde | grep false >/dev/null ; then
            RESULT="☿ \033[0;32mPrograde\033[0m"
        else
            RESULT="☿ \033[0;31mRetrograde\033[0m"
        fi

    fi
    echo -e $RESULT
}

export PS1="[\[\e[36m\]\u\[\e[m\]@\[\e[36m\]\h\[\e[m\]] \`get_mercury_retrograde\` \w\n\[\e[35m\]\\$\[\e[m\] "

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
